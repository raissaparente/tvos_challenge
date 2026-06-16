//
//  LetterDrawViewModel.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 13/06/25.
//
import Foundation
import Combine

class LetterDrawViewModel {
    private let connectionManager: ConnectionManager
    private let gameService: GameService
    
    @Published var canGoToCategory = false
    
    init(connectionManager: ConnectionManager, gameService: GameService) {
        self.connectionManager = connectionManager
        self.gameService = gameService
        
        startCountdown()
    }
    
    private func startCountdown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.gameService.status = .category
            
            // payload com o novo status
            let payload = ChangeStatusPayload(status: .category)
            let action = GameAction(type: .changeStatus, payload: payload)
            
            // envia para os peers
            self.connectionManager.send(gameAction: action)
            
//             self.canGoToCategory = true
        }
    }
    
}
