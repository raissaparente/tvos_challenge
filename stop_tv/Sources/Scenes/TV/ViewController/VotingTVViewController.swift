//
//  VotingViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 17/06/25.
//

import UIKit
import Combine

class VotingTVViewController: UIViewController {
    var viewModel: RoundViewModel
    var coordinator: AppCoordinator
    
    private var cancellables = Set<AnyCancellable>()

    // UI...
    private let containerView = UIView()
    private let textField = UITextField()
    private let categoryLabel = UILabel()
//    private let submitButton = UIButton(type: .custom)
    private let finishButton = UIButton(type: .custom)
    private let submitButton = UIButton(type: .custom)

    private let stackView = UIStackView()


    init(viewModel: RoundViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        observeViewModel()
        reloadWords()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
    }

    private func observeViewModel() {
        
        viewModel.gameService.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                
                if status == .endVote {
                    print("VOTINGTV terminou votação -> chama changeCat e troca tela")
                    
                    if viewModel.isLastCategory {
                        coordinator.showPartialRanking_TV(from: self)
                        //TODO: AVISAR PRO CELULAR IR PRA UMA TELA DE ESPERA
                    } else {
                        self.viewModel.changeCategory()
                        coordinator.showCategory_TV(from: self)
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func setupLayout() {
        
        // Container setup
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .lightGray
        containerView.layer.cornerRadius = 12
        view.addSubview(containerView)

        // Category label
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = viewModel.currentCategory
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 24)
        containerView.addSubview(categoryLabel)
        
        // Words
        stackView.axis = .vertical
                stackView.spacing = 12
                stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)
        
        // Continuar button
        submitButton.setTitle("Todos votaram", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 21, weight: .medium)
        submitButton.backgroundColor = .darkGray
        submitButton.layer.cornerRadius = 8
        submitButton.clipsToBounds = true
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(handleEndVotingButtonTapped), for: .primaryActionTriggered)
        containerView.addSubview(submitButton)

        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            categoryLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: categoryLabel.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            submitButton.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            submitButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

        ])
    }

    
    
    private func reloadWords() {
            for view in stackView.arrangedSubviews where view.tag == 100 {
                stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        
        guard let words = viewModel.answers[viewModel.currentCategory] else { return }
            
            for word in words {
                let label = UILabel()
                label.tag = 100
                label.text = word
                label.textColor = .white
                stackView.addArrangedSubview(label)
            }
     }

    @objc private func handleEndVotingButtonTapped(_ sender: UIButton) {
        //Vai ser um observador de quem votou/timer
        print("Executou ação da ação")
        viewModel.endVoting()        
    }
}


#Preview {
    VotingTVViewController(viewModel: RoundViewModel( connectionManager: ConnectionManager(username: "julia"), gameService: GameService()), coordinator: AppCoordinator(window: .init(), username: ""))
}
