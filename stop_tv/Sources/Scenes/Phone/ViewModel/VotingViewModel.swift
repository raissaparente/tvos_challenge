//
//  VotingViewModel.swift
//  stop_tv
//
//  Created by Júlia Saboya on 25/06/25.
//
import Foundation

class VotingViewModel {
    let round: RoundViewModel
    @Published var votesByCategory: [String: [Int: [Bool]]] = [:]
    @Published var playersWhoVotedByCategory: [String: Set<String>] = [:]
    @Published var selectedAnswerIndexes: Set<Int> = []
    
     var hasHandledEndVote = false


    init(round: RoundViewModel) {
        self.round = round
    }

    var totalPlayers: Int {
        round.connectionManager.connectedPeers.count
    }

    func sendVote() {
        let category = round.currentCategory
        let voterName = round.connectionManager.myPeerId.displayName
        let payload = VotePayload(
            category: category,
            voterName: voterName,
            selectedIndexes: selectedAnswerIndexes
        )

        let action = GameAction(type: .voteAnswer, payload: payload)
        round.connectionManager.send(gameAction: action)

        // ✅ Aplica o próprio voto localmente, já que MCSession não envia pra si mesmo
        appendRemotePlayerVote(
            voterName: voterName,
            selectedIndexes: selectedAnswerIndexes,
            category: category
        )
    }

    func appendRemotePlayerVote(voterName: String, selectedIndexes: Set<Int>, category: String) {
        var votesForCategory = votesByCategory[category] ?? [:]
        var playersWhoVoted = playersWhoVotedByCategory[category] ?? Set()
        playersWhoVoted.insert(voterName)
        playersWhoVotedByCategory[category] = playersWhoVoted

        let totalAnswers = round.answers[category]?.count ?? 0

        for index in 0..<totalAnswers {
            let isSelected = selectedIndexes.contains(index)
            let vote = !isSelected
            var currentVotes = votesForCategory[index] ?? []
            currentVotes.append(vote)
            votesForCategory[index] = currentVotes
        }

        votesByCategory[category] = votesForCategory
        checkIfAllPlayersVoted()
    }

    func appendPlayerVote(selectedIndexes: Set<Int>, totalAnswers: Int) {
        let category = round.currentCategory
        let playerName = round.connectionManager.myPeerId.displayName
        var votesForCategory = votesByCategory[category] ?? [:]

        var playersWhoVoted = playersWhoVotedByCategory[category] ?? Set()
        playersWhoVoted.insert(playerName)
        playersWhoVotedByCategory[category] = playersWhoVoted

        for index in 0..<totalAnswers {
            let isSelected = selectedIndexes.contains(index)
            let vote = !isSelected // false se selecionado, true se não (penalidade)
            var currentVotes = votesForCategory[index] ?? []
            currentVotes.append(vote)
            votesForCategory[index] = currentVotes
        }

        votesByCategory[category] = votesForCategory
        checkIfAllPlayersVoted()
    }

    private func checkIfAllPlayersVoted() {
        let category = round.currentCategory
        let playersWhoVoted = playersWhoVotedByCategory[category] ?? Set()
        let totalVoted = playersWhoVoted.count

        if totalVoted >= totalPlayers {
            guard !round.isFinished else {
                return
            }

            finalizeVotes()
            endVoting()
        }
    }

    func finalizeVotes() {
        let category = round.currentCategory
        guard let answerList = round.answers[category] else {
            return
        }

        var votesForCategory = votesByCategory[category] ?? [:]

        for index in 0..<answerList.count {
            var current = votesForCategory[index] ?? []
            let missing = totalPlayers - current.count
            if missing > 0 {
                current.append(contentsOf: Array(repeating: true, count: missing))
            }
            votesForCategory[index] = current
        }

        votesByCategory[category] = votesForCategory

        for (index, votos) in votesForCategory.sorted(by: { $0.key < $1.key }) {
            print("📊 [\(category)] Resposta \(index): \(votos)")
        }
    }

    func endVoting() {
        let payload = ChangeStatusPayload(status: .endVote)
        let action = GameAction(type: .changeStatus, payload: payload)
        round.connectionManager.send(gameAction: action)
        round.gameService.status = .endVote
    }

}

