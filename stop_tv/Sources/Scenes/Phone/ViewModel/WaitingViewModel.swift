//
//  WaitingViewModel.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 13/06/25.
//
import Foundation
import Combine

enum WaitingType {
    case explaining
    case waitingForAnswers
    case waitingForEndVote
}

class WaitingViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private let connectionManager: ConnectionManager
    let gameService: GameService
    
    var waitingType: WaitingType
    var waitingText = "Waiting"
    
    @Published var didFinishWaiting: Bool = false
    
    init(connectionManager: ConnectionManager, gameService: GameService, type: WaitingType) {
        self.connectionManager = connectionManager
        self.gameService = gameService
        self.waitingType = type
                
    }
    
    var expectedStatus: ConnectionStatus {
         switch waitingType {
         case .explaining:
             return .startGame
         case .waitingForAnswers:
             return .startVote
         case .waitingForEndVote:
             return .endVote
         }
     }
    func cancelObservers() {
        cancellables.removeAll()
    }
}
