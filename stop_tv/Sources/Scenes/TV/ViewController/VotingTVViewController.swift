//
//  VotingViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 17/06/25.
//

import UIKit
import Combine

class VotingTVViewController: UIViewController {
    var roundVM: RoundViewModel
    var coordinator: AppCoordinator
    var votingVM: VotingViewModel

    private var cancellables = Set<AnyCancellable>()

    // UI...
    private let containerView = UIView()
    private let categoryLabel = UILabel()
    private let finishButton = UIButton(type: .custom)

    private let stackView = UIStackView()

    init(viewModel: RoundViewModel, coordinator: AppCoordinator, votingVM: VotingViewModel) {
        self.roundVM = viewModel
        self.coordinator = coordinator
        self.votingVM = votingVM
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupLayout()
        observeViewModel()
        reloadWords()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
    }

    private func observeViewModel() {
        roundVM.gameService.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                
                if status == .endVote {
                    
                    if roundVM.isLastCategory {
                        coordinator.showPartialRanking_TV(from: self)
                        //TODO: AVISAR PRO CELULAR IR PRA UMA TELA DE ESPERA
                    } else {
                        self.roundVM.changeCategory()
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
        categoryLabel.text = roundVM.currentCategory
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 24)
        containerView.addSubview(categoryLabel)
        
        // Words
        stackView.axis = .vertical
                stackView.spacing = 12
                stackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stackView)


        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            categoryLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            stackView.topAnchor.constraint(equalTo: categoryLabel.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),


        ])
    }

    
    
    private func reloadWords() {
            for view in stackView.arrangedSubviews where view.tag == 100 {
                stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        
        guard let words = roundVM.answers[roundVM.currentCategory] else { return }
            
            for word in words {
                let label = UILabel()
                label.tag = 100
                label.text = word.text
                label.textColor = .white
                stackView.addArrangedSubview(label)
            }
     }
}

//
//#Preview {
//    VotingTVViewController(viewModel: RoundViewModel( connectionManager: ConnectionManager(username: "julia"), gameService: GameService()), coordinator: AppCoordinator(window: .init(), username: ""), votingVM: VotingViewModel(round: RoundViewModel()))
//}
