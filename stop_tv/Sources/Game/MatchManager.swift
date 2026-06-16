//
//  MatchManager.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//

import Foundation
import MultipeerConnectivity
import StopPlay

class MatchManager: ObservableObject {
    @Published var maxRoundsCount: Int = 2
    @Published var currentRound: Int = 0
    @Published var isGameFinished: Bool = false
    @Published var isRoundFinished: Bool = false
    
    var letters: [String] = []
    var players: [Player] = []
    
    var currentLetter: String? {
        guard letters.indices.contains(currentRound) else { return nil }
        return letters[currentRound]
    }
    
    func finishRound() {
        isRoundFinished = true
        
        if isLastRound {
            finishGame()
        } else {
            advanceToNextRound()
        }
    }
    
    private func advanceToNextRound() {
        currentRound += 1
        isRoundFinished = false
    }
    
    private func finishGame() {
        isGameFinished = true
    }
    
    //só no fim do jogo todo
    func resetGame() {
        currentRound = 0
        letters.removeAll()
        isGameFinished = false
        isRoundFinished = false
    }
    
    var isLastRound: Bool {
        return currentRound >= maxRoundsCount - 1
    }
}
