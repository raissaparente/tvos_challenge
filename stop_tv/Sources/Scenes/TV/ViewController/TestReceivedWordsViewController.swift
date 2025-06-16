//
//  TestReceivedWordsViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//


import UIKit
import Combine
import MultipeerConnectivity

class TestReceivedWordsViewController: UIViewController {
    
    private var cancellables = Set<AnyCancellable>()
    
    private let coordinator: AppCoordinator
    private let gameService: GameService
    
    private let stackView = UIStackView()
    
    init(coordinator: AppCoordinator, gameService: GameService) {
        self.coordinator = coordinator
        self.gameService = gameService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        observeWordList()
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
        titleLabel.text = "Letra \(gameService.currentLetter)"
        stackView.addArrangedSubview(titleLabel)
    }
    
    //combine
    private func observeWordList() {
        gameService.$dump
            .receive(on: DispatchQueue.main)
            .sink { [weak self] words in
                self?.reloadWords(words)
            }
            .store(in: &cancellables)
    }
    
    private func reloadWords(_ words: [String]) {
        for view in stackView.arrangedSubviews where view.tag == 100 {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for word in words {
            let label = UILabel()
            label.tag = 100
            label.text = word
            label.textColor = .white
            stackView.addArrangedSubview(label)
        }
    }
    
    @objc private func inviteTapped() {
        
    }
}
