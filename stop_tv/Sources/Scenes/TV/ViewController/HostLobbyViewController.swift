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
    
    private let interfaceView = HostLobbyView()
    
    
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
        interfaceView.rightPanel.inviteButton.addTarget(self, action: #selector(inviteTapped), for: .primaryActionTriggered)
        
        
        viewModel.browseForPeers()
        viewModel.observeConnection()
        viewModel.observeGame()
        
        observeVM()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopBrowsingForPeers()
    }
    
    
    private func observeVM() {
        viewModel.$availablePeers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] peers in
                self?.reloadPlayers(from: peers)
            }
            .store(in: &cancellables)
        
        
    }
    
    private func reloadPlayers(from peers: [MCPeerID]) {
        let nameList = interfaceView.rightPanel.nameList
        nameList.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for nome in peers {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            
            let label = UILabel()
            label.text = nome.displayName
            label.font = UIFont(name: "ClashDisplay-Regular", size: 30)
            label.textColor = .black
            label.translatesAutoresizingMaskIntoConstraints = false
            
            let underline = UIView()
            underline.backgroundColor = UIColor.systemBlue
            underline.translatesAutoresizingMaskIntoConstraints = false
            
            container.addSubview(label)
            container.addSubview(underline)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: container.topAnchor),
                label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                
                underline.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 2),
                underline.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                underline.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                underline.heightAnchor.constraint(equalToConstant: 5),
                underline.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])
            
            nameList.addArrangedSubview(container)
        }
    }
    
    @objc private func inviteTapped() {
        viewModel.inviteAvailablePeers()
        coordinator.showGameInstruction_TV(from: self)
    }
    
    func addBackgroundImage(named imageName: String, to containerView: UIView) {
        let backgroundImageView = UIImageView(image: UIImage(named: imageName))
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.clipsToBounds = true
        
        containerView.addSubview(backgroundImageView)
        containerView.sendSubviewToBack(backgroundImageView)
        containerView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
}
