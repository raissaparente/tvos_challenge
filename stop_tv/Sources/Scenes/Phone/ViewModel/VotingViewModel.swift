//
//  VotingViewModel.swift
//  stop_tv
//
//  Created by Júlia Saboya on 25/06/25.
//
import Foundation

class VotingViewModel: RoundViewModel {
    @Published var votes: [Int: [Bool]] = [:]

    var totalPlayers: Int {
        connectionManager.connectedPeers.count
    }


    func appendPlayerVote(for index: Int){
        var currentVotes = votes[index] ?? []
        currentVotes.append(false)
        votes[index] = currentVotes

        print("🗳️ Voto registrado: \(votes)")
        checkIfAllPlayersVoted()

    }

    func endVoting(){
        //é chamada na TV
        let payload = ChangeStatusPayload(status: .endVote)
        let action = GameAction(type: .changeStatus, payload: payload)
        connectionManager.send(gameAction: action)

        //local
        self.gameService.status = .endVote
    }

    private func checkIfAllPlayersVoted() {
        let totalVotes = votes.values.flatMap { $0 }.count
        if totalVotes >= totalPlayers {
            endVoting()
            print("✅ Todos os jogadores votaram! (\(totalVotes)/\(totalPlayers))")
            finalizeVotes()
        }
    }

    func finalizeVotes() {
        guard let answerList = answers[currentCategory] else { return }
        for index in 0..<answerList.count {
            var current = votes[index] ?? []
            let missing = totalPlayers - current.count
            if missing > 0 {
                current.append(contentsOf: Array(repeating: true, count: missing))
            }
            votes[index] = current
        }

        print("🔚 Votos finalizados com preenchimento: \(votes)")
    }
}
