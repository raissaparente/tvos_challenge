//
//  ConnectionInstructionViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//

import UIKit
import Combine
import MultipeerConnectivity

class ConnectionInstructionViewController: UIViewController {
    
    private let connectionManager: ConnectionManager
    private let gameService: GameService
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Abra/baixe o app e escolha um nome"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continuar", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
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
        setupButton()
    }
    
    func setupUI() {
        view.backgroundColor = .black

        view.addSubview(descriptionLabel)
        view.addSubview(startButton)
        
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            startButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 100),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    private func setupButton() {
        startButton.addTarget(self, action: #selector(continueTapped), for: .primaryActionTriggered)
    }

    
    @objc private func continueTapped() {
        print("didtap")
        navigationController?.pushViewController(HostLobbyViewController(connectionManager: connectionManager, gameService: gameService), animated: false)
    }
}
