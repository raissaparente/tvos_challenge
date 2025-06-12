//
//  PlayerLobbyViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//
import UIKit
import Combine


class PlayerLobbyViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    private let connectionManager: ConnectionManager
    private let gameService: GameService
    
    private let statusLabel = UILabel()

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
        connectionManager.startAdvertising()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        statusLabel.text = "Conectando à TV..."
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //pra mostrar o popup de conectar -> trocar por codigo da "sala?
    private func observeInvite() {
         connectionManager.$receivedInvite
             .receive(on: DispatchQueue.main)
             .sink { [weak self] received in
                 guard let self = self, received else { return }
                 self.showInviteAlert()
             }
             .store(in: &cancellables)
     }
    
    private func showInviteAlert() {
        let peerName = connectionManager.receivedInviteFrom?.displayName ?? "Unknown"
        let alert = UIAlertController(
            title: "Convite recebido",
            message: "Recebido de \(peerName)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Aceitar", style: .default) { _ in
            self.connectionManager.invitationHandler?(true, self.connectionManager.session)
        })
        alert.addAction(UIAlertAction(title: "Recusar", style: .cancel) { _ in
            self.connectionManager.invitationHandler?(false, nil)
        })
        present(alert, animated: true)
    }
}
