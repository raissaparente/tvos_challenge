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
    
    private let viewModel: PlayerLobbyViewModel
    private let coordinator: AppCoordinator
    
    
    private let statusLabel = UILabel()

    init(viewModel: PlayerLobbyViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        observeViewModel()
    }
    
    
    
    func setupUI() {
        view.backgroundColor = .white
        statusLabel.text = "Conectando à TV..."
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func observeViewModel() {
            viewModel.$shouldShowInvite
                .filter { $0 }
                .sink { [weak self] _ in self?.showInviteAlert() }
                .store(in: &cancellables)

            viewModel.$shouldNavigateToGame
                .filter { $0 }
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    
                    coordinator.showWaitingMessage_phone(from: self, type: .explaining)
                }
                .store(in: &cancellables)
    }
    
    private func showInviteAlert() {
            let peerName = viewModel.receivedInviteFrom?.displayName ?? "Desconhecido"
            let alert = UIAlertController(
                title: "Convite recebido",
                message: "Recebido de \(peerName)",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Aceitar", style: .default) { _ in
                self.viewModel.acceptInvite()
            })
            alert.addAction(UIAlertAction(title: "Recusar", style: .cancel) { _ in
                self.viewModel.declineInvite()
            })
            present(alert, animated: true)
   }
}
