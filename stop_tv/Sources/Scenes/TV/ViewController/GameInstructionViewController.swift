//
//  GameInstructionViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//


import UIKit
import Combine
import MultipeerConnectivity

class GameInstructionViewController: UIViewController {
    
    private let interfaceView = GameInstructionPostitView()
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: HostLobbyViewModel
    private let coordinator: AppCoordinator
    
    init(viewModel: HostLobbyViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = interfaceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interfaceView.bottomPanel.inviteButton.addTarget(self, action: #selector(continueTapped), for: .primaryActionTriggered)
        
        observeVM()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
    }
    
    private func observeVM() {
        viewModel.connectionManager.$connectedPeers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] peers in
                let peerNames = peers.map( \.displayName )
                
                self?.interfaceView.bottomPanel.reloadPlayers(from: peerNames)
            }
            .store(in: &cancellables)
        
        
        viewModel.$shouldStartGame
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldStart in
                print("chamou observer vc1")
                
                guard let self = self else { return }
                
                if shouldStart {
                    print("chamou observer vc2")
                    coordinator.showLetterDraw_TV(from: self)
                }
            }
            .store(in: &cancellables)
    }

    private func emptyListAlert() -> UIAlertController {
        let alertController = UIAlertController(
            title: "Sem Jogadores Conectados",
            message: "Pelo menos um jogador deve aceitar o convite para iniciar o jogo!",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "Entendi!", style: .default)
        alertController.addAction(okAction)

        return alertController
    }

    @objc private func continueTapped() {
        if viewModel.connectionManager.connectedPeers.isEmpty {
            present(emptyListAlert(), animated: true, completion: nil)


        } else {
            viewModel.startGame()
        }
    }
}
