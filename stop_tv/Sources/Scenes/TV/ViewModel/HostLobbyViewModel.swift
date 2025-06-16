//
//  HostLobbyViewModel.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//

import Combine
import MultipeerConnectivity

class HostLobbyViewModel: ObservableObject {
    @Published var selectedPeers: [MCPeerID] = []
    @Published var availablePeers: [MCPeerID] = []
    @Published var shouldStartGame: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let connectionManager: ConnectionManager
    private let gameService: GameService
    
    init(connectionManager: ConnectionManager, gameService: GameService) {
        self.connectionManager = connectionManager
        self.gameService = gameService
    }
    
    
    func observeConnection() {
        //observa peers disponíveis
        connectionManager.$availablePeers
            .receive(on: DispatchQueue.main)
            .assign(to: &$availablePeers)
        
        //observa peers conectados
        connectionManager.$connectedPeers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connected in
                guard let self = self else { return }
                guard !selectedPeers.isEmpty else { return }
                if Set(connected) == Set(self.selectedPeers) {
                    let action = GameAction(action: .changeStatus, status: .startGame)
                    self.connectionManager.send(gameAction: action)
                    self.gameService.status = .startGame
                }
            }
            .store(in: &cancellables)
    }
    
    func observeGame() {
        // Observa início do jogo
        gameService.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                if status == .startGame {
                    self?.shouldStartGame = true
                }
            }
            .store(in: &cancellables)
    }
    
    func browseForPeers() {
        connectionManager.setup(game: gameService)
        connectionManager.startBrowsing()
    }
    
    func stopBrowsingForPeers() {
        connectionManager.stopBrowsing()
    }
    
    func inviteSelectedPeers() {
        for peer in selectedPeers {
            connectionManager.invite(peer: peer)
        }
    }
    
    func toggleSelection(for peer: MCPeerID) {
        if selectedPeers.contains(peer) {
            selectedPeers.removeAll { $0 == peer }
        } else {
            selectedPeers.append(peer)
        }
    }
}
