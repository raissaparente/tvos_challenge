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
    
    let postitView = PostitAlertView()

    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Procurando a partida...\nFique por perto, já vai começar"
        label.font = UIFont(name: "Clash Display", size: 20)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

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
        view.addBackgroundView(StarsBackgroundView())

        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func observeViewModel() {
            viewModel.$shouldShowInvite
                .filter { $0 }
                .sink { [weak self] _ in self?.showPostit() }
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
    
    @objc func acceptInvite() {
        print("func accept")
        viewModel.acceptInvite()
    }
    
    @objc func rejectInvite() {
        viewModel.declineInvite()
    }
    
    func showPostit() {
        view.addSubview(postitView)
        
        NSLayoutConstraint.activate([
            postitView.topAnchor.constraint(equalTo: view.topAnchor),
            postitView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            postitView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postitView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        postitView.acceptButton.addTarget(self, action: #selector(acceptInvite), for: .touchUpInside)
        postitView.refuseButton.addTarget(self, action: #selector(rejectInvite), for: .touchUpInside)
    }
}
