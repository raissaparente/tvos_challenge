//
//  LetterDrawViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//
import UIKit
import Combine


class LetterDrawViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    private let connectionManager: ConnectionManager
    private let gameService: GameService
    
    private let letter: UILabel = {
        let label = UILabel()
        label.text = "A"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 100, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        connectionManager.setup(game: gameService)
        connectionManager.startAdvertising()
        
        startCountdown()
    }
    
    func setupUI() {
        view.backgroundColor = .white

        view.addSubview(letter)
        NSLayoutConstraint.activate([
            letter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            letter.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //navega pro categoria depois da animacao(?)
    private func observeStatus() {
        gameService.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }

                if status == .startGame {
                    
                }
            }
            .store(in: &cancellables)
    }
    
    
    private func startCountdown() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.gameService.status = .category
            
            //sends to phones
            let action = GameAction(action: .changeStatus, playerName: self.connectionManager.myPeerId.displayName, status: .category)
            self.connectionManager.send(gameAction: action)
            
            self.navigationController?.pushViewController(CategoryViewController(connectionManager: self.connectionManager, gameService: self.gameService), animated: false)
        }
    }
}
