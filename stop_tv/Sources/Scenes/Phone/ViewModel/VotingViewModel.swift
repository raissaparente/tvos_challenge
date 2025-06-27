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

    init(round: RoundViewModel) {
        self.round = round
    }

    var totalPlayers: Int {
        round.connectionManager.connectedPeers.count
    }

    func appendPlayerVote(selectedIndexes: Set<Int>, totalAnswers: Int) {
        let category = round.currentCategory
        var votesForCategory = votesByCategory[category] ?? [:]

        for index in 0..<totalAnswers {
            let isSelected = selectedIndexes.contains(index)
            let vote = !isSelected // false se selecionado, true se não (penalidade)
            var currentVotes = votesForCategory[index] ?? []
            currentVotes.append(vote)
            votesForCategory[index] = currentVotes
            print("🔹 Categoria: \(category), Voto para índice \(index): \(vote), total votos agora: \(currentVotes.count)")
        }

        votesByCategory[category] = votesForCategory

        print("📦 Total de votos para categoria \(category): \(votesByCategory[category] ?? [:])")

        checkIfAllPlayersVoted()
    }

    private func checkIfAllPlayersVoted() {
        let category = round.currentCategory
        let allVotes = votesByCategory[category]?.values.flatMap { $0 } ?? []
        let totalVotes = allVotes.count

        print("checkIfAllPlayersVoted [\(category)] - totalVotes: \(totalVotes), totalPlayers: \(totalPlayers)")

        if totalVotes >= totalPlayers {
            print("✅ Todos os jogadores votaram na categoria \(category)")

            guard !round.isFinished else {
                print("🏁 Rodada finalizada")
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

