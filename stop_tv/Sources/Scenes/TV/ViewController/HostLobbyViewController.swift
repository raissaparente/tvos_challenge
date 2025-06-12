//
//  HostLobbyViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//
import UIKit
import Combine
import MultipeerConnectivity

class HostLobbyViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let connectionManager: ConnectionManager
    private let gameService: GameService
    private let viewModel = HostLobbyViewModel()
    
    private let stackView = UIStackView()
    
    init(connectionManager: ConnectionManager, gameService: GameService) {
        self.connectionManager = connectionManager
        self.gameService = gameService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        connectionManager.setup(game: gameService)
        connectionManager.startBrowsing()
        
        observePeers()
        observeConnection()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        connectionManager.stopBrowsing()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .white
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "Jogadores disponíveis:"
        stackView.addArrangedSubview(titleLabel)
        
        let inviteButton = UIButton(type: .system)
        inviteButton.setTitle("Convidar selecionados", for: .normal)
        inviteButton.addTarget(self, action: #selector(inviteTapped), for: .touchUpInside)
        stackView.addArrangedSubview(inviteButton)
    }
    
    //combine
    private func observePeers() {
        connectionManager.$availablePeers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] peers in
                self?.reloadPeerButtons(peers)
                print(self?.connectionManager.availablePeers)
            }
            .store(in: &cancellables)
    }
    
    private func observeConnection() {
        connectionManager.$connectedPeers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connected in
                guard let self = self else { return }
                
                //inicio do jogo quando todo mundo aceitar
                if Set(connected) == Set(self.viewModel.selectedPeers) {
                    self.gameService.startGame = true
                    let action = GameAction(action: .startGame, playerName: nil, category: nil, answer: nil, isAnswerValid: nil)
                    self.connectionManager.send(gameAction: action)
                }
            }
            .store(in: &cancellables)
    }
    
    private func reloadPeerButtons(_ peers: [MCPeerID]) {
        stackView.arrangedSubviews
            .dropFirst()
            .forEach { $0.removeFromSuperview() }
        
        for peer in peers {
            let button = UIButton(type: .system)
            let isSelected = viewModel.selectedPeers.contains(peer)
            let symbol = isSelected ? "✅" : "◻️"
            button.setTitle("\(symbol) \(peer.displayName)", for: .normal)
            button.addAction(UIAction { [weak self] _ in
                self?.viewModel.toggleSelection(for: peer)
                self?.reloadPeerButtons(peers)
            }, for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func inviteTapped() {
        for peer in viewModel.selectedPeers {
            connectionManager.invite(peer: peer)
        }
    }
}
