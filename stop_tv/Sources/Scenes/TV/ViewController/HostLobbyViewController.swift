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
    
    private let viewModel: HostLobbyViewModel
    private let coordinator: AppCoordinator
    
    private let stackView = UIStackView()
    
    init(viewModel: HostLobbyViewModel, coordinator: AppCoordinator) {
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
        
        viewModel.browseForPeers()
        viewModel.observeConnection()
        viewModel.observeGame()
        
        observeVM()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopBrowsingForPeers()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .black
        
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
        titleLabel.textColor = .white
        stackView.addArrangedSubview(titleLabel)
        
        let inviteButton = UIButton(type: .system)
        inviteButton.setTitle("Convidar selecionados", for: .normal)
        inviteButton.backgroundColor = .systemBlue
        inviteButton.tintColor = .white
        inviteButton.layer.cornerRadius = 8
        inviteButton.addTarget(self, action: #selector(inviteTapped), for: .primaryActionTriggered)
        stackView.addArrangedSubview(inviteButton)
    }
    
    private func observeVM() {
        viewModel.$availablePeers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] peers in
                self?.reloadPeerButtons(peers)
            }
            .store(in: &cancellables)
        
        viewModel.$shouldStartGame
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldStart in
                guard let self = self else { return }
                
                if shouldStart {
                    coordinator.showGameInstruction_TV(from: self)
                }
            }
            .store(in: &cancellables)
    }
    private func reloadPeerButtons(_ peers: [MCPeerID]) {
        for view in stackView.arrangedSubviews where view.tag == 100 {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for peer in peers {
            let button = UIButton(type: .system)
            button.tag = 100
            let isSelected = viewModel.selectedPeers.contains(peer)
            let symbol = isSelected ? "✅" : "◻️"
            button.setTitle("\(symbol) \(peer.displayName)", for: .normal)
            button.tintColor = .white
            button.addAction(UIAction { [weak self] _ in
                self?.viewModel.toggleSelection(for: peer)
                self?.reloadPeerButtons(peers)
            }, for: .primaryActionTriggered)
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc private func inviteTapped() {
        viewModel.inviteSelectedPeers()
    }
}
