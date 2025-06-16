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
    
    var text: String {
        switch self {
        case .explaining:
            "Explicando o jogo"
        }
    }
}

class WaitingViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private let connectionManager: ConnectionManager
    private let gameService: GameService
    
    var waitingType: WaitingType
    var waitingText = "Waiting"
    
    @Published var didFinishWaiting: Bool = false
    
    init(connectionManager: ConnectionManager, gameService: GameService, type: WaitingType) {
        self.connectionManager = connectionManager
        self.gameService = gameService
        self.waitingType = type
        
        waitingText = waitingType.text
        
        observeGameStatus()
    }
    
    private func observeGameStatus() {
        gameService.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }
                
                switch self.waitingType {
                case .explaining:
                    if status == .category {
                        self.didFinishWaiting = true
                    }
                    // outros tipos, se existirem
                }
            }
            .store(in: &cancellables)
    }
}
