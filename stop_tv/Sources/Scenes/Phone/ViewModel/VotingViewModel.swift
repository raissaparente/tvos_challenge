//
//  VotingViewModel.swift
//  stop_tv
//
//  Created by Júlia Saboya on 25/06/25.
//
import Foundation
import StopPlay

class VotingViewModel {
    let round: RoundViewModel
    @Published var votesByCategory: [String: [UUID: [Bool]]] = [:]
    @Published var playersWhoVotedByCategory: [String: Set<String>] = [:]
    @Published var selectedAnswerIndexes: Set<Int> = []

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
        guard let answers = round.answers[category] else { return }

        var votesForCategory = votesByCategory[category] ?? [:]
        var playersWhoVoted = playersWhoVotedByCategory[category] ?? Set()
        playersWhoVoted.insert(voterName)
        playersWhoVotedByCategory[category] = playersWhoVoted

        for (index, answer) in answers.enumerated() {
            let isSelected = selectedIndexes.contains(index)
            let vote = !isSelected
            var currentVotes = votesForCategory[answer.id] ?? []
            currentVotes.append(vote)
            votesForCategory[answer.id] = currentVotes
        }

        votesByCategory[category] = votesForCategory
        checkIfAllPlayersVoted()
    }

    func appendPlayerVote(selectedIndexes: Set<Int>, totalAnswers: Int) {
        let category = round.currentCategory
        guard let answers = round.answers[category] else { return }
        let playerName = round.connectionManager.myPeerId.displayName

        var votesForCategory = votesByCategory[category] ?? [:]
        var playersWhoVoted = playersWhoVotedByCategory[category] ?? Set()
        playersWhoVoted.insert(playerName)
        playersWhoVotedByCategory[category] = playersWhoVoted

        for (index, answer) in answers.enumerated() {
            let isSelected = selectedIndexes.contains(index)
            let vote = !isSelected
            var currentVotes = votesForCategory[answer.id] ?? []
            currentVotes.append(vote)
            votesForCategory[answer.id] = currentVotes
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
        guard let answers = round.answers[category] else { return }

        var votesForCategory = votesByCategory[category] ?? [:]

        for answer in answers {
            var current = votesForCategory[answer.id] ?? []
            let missing = totalPlayers - current.count
            if missing > 0 {
                current.append(contentsOf: Array(repeating: true, count: missing))
            }
            votesForCategory[answer.id] = current
        }

        votesByCategory[category] = votesForCategory

        for (index, answer) in answers.enumerated() {
            let votes = votesForCategory[answer.id] ?? []
            print("📊 [\(category)] Resposta \(index): \(votes)")
        }
    }

    func endVoting() {
        let category = round.currentCategory

        if let respostas = round.answers[category] {
                print("📊 Calculando pontuação das respostas da categoria '\(category)'...")
                for resposta in respostas {
                    let score = round.calculateScore(for: resposta, in: category)
                    print("✅ '\(resposta.text)': \(score) pontos")
                }
            } else {
                print("⚠️ Nenhuma resposta encontrada para a categoria '\(category)'")
            }
        let payload = ChangeStatusPayload(status: .endVote)
        let action = GameAction(type: .changeStatus, payload: payload)
        round.connectionManager.send(gameAction: action)
        round.gameService.status = .endVote

    }


}

