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
    
    let connectionManager: ConnectionManager
    let gameService: GameService
    let roundViewModel: RoundViewModel
    let matchManager: MatchManager
    let votingViewModel: VotingViewModel

    
    init(connectionManager: ConnectionManager, gameService: GameService, roundViewModel: RoundViewModel, matchManager: MatchManager, votingViewModel: VotingViewModel) {
        self.connectionManager = connectionManager
        self.gameService = gameService
        self.roundViewModel = roundViewModel
        self.matchManager = matchManager
        self.votingViewModel = votingViewModel
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
                    startGame()
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
        connectionManager.setup(game: gameService, round: roundViewModel, votingVM: votingViewModel)
        connectionManager.startBrowsing()
    }
    
    func stopBrowsingForPeers() {
        connectionManager.stopBrowsing()
    }
    
    func inviteAvailablePeers() {
        selectedPeers = availablePeers
        
        for peer in availablePeers {
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
    
    func startGame() {
        // payload com o novo status
        let payload = ChangeStatusPayload(status: .startGame)

        let action = GameAction(type: .changeStatus, payload: payload)
        
        // envia para os peers
        self.connectionManager.send(gameAction: action)
        
        //guarda os jogadores
        let players = gameService.makePlayers(from: selectedPeers)
        matchManager.players = players
        self.gameService.status = .startGame
    }
}
