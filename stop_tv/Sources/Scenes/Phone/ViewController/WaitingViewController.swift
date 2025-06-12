//
//  WaitingViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//

import UIKit
import Combine


class WaitingViewController: UIViewController {
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
        
        observeGameStatus()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        statusLabel.text = "Waiting"
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //navega
    private func observeGameStatus() {
        gameService.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }

                if status == .category {
                    navigationController?.pushViewController(AnswerViewController(connectionManager: self.connectionManager, gameService: self.gameService), animated: false)
                }
            }
            .store(in: &cancellables)
    }
}
