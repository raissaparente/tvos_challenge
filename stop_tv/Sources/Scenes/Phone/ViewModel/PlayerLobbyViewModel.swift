//
//  PlayerLobbyViewModel.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 13/06/25.
//

import Combine
import MultipeerConnectivity

class PlayerLobbyViewModel: ObservableObject {
    
    @Published var shouldShowInvite: Bool = false
    @Published var shouldNavigateToGame: Bool = false
    @Published var receivedInviteFrom: MCPeerID?

    private let connectionManager: ConnectionManager
    private let gameService: GameService
    private let roundViewModel: RoundViewModel

    private var cancellables = Set<AnyCancellable>()

    init(connectionManager: ConnectionManager, gameService: GameService, roundViewModel: RoundViewModel) {
        self.connectionManager = connectionManager
        self.gameService = gameService
        self.roundViewModel = roundViewModel

        observeConnection()
        observeGame()
        
        connectionManager.setup(game: gameService, round: roundViewModel)
        connectionManager.startAdvertising()
    }

    func observeConnection() {
        connectionManager.$receivedInvite
            .receive(on: DispatchQueue.main)
            .sink { [weak self] received in
                guard let self = self else { return }
                if received {
                    self.receivedInviteFrom = self.connectionManager.receivedInviteFrom
                    self.shouldShowInvite = true
                }
            }
            .store(in: &cancellables)
    }
    
    func observeGame() {
        gameService.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status == .startGame {
                    self?.shouldNavigateToGame = true
                }
            }
            .store(in: &cancellables)
    }

    func acceptInvite() {
        connectionManager.invitationHandler?(true, connectionManager.session)
    }

    func declineInvite() {
        connectionManager.invitationHandler?(false, nil)
    }
}
