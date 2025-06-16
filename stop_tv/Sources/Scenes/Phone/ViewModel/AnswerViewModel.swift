//
//  AnswerViewModel.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 13/06/25.
//
import Foundation
import Combine

class AnswerViewModel: ObservableObject {
    private let connectionManager: ConnectionManager
    private let gameService: GameService
    
    var answer: String = ""

    
    init(connectionManager: ConnectionManager, gameService: GameService) {
        self.connectionManager = connectionManager
        self.gameService = gameService
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendAnswer() {
        let gameaction = GameAction(action: .sendAnswer, playerName: connectionManager.myPeerId.displayName, category: gameService.currentCategory, answer: answer, isAnswerValid: nil)
        
        connectionManager.send(gameAction: gameaction)
    }
}
