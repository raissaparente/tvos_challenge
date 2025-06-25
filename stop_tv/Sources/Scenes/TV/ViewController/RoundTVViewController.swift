//
//  RoundTestViewController.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//

import UIKit
import Combine

class RoundTVViewController: UIViewController {
    var viewModel: RoundViewModel
    var coordinator: AppCoordinator
    private var cancellables = Set<AnyCancellable>()

    // UI...
    private let containerView = UIView()
    private let textField = UITextField()
    private let categoryLabel = UILabel()
//    private let submitButton = UIButton(type: .custom)
    private let finishButton = UIButton(type: .custom)
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
        view.backgroundColor = .black

        print("A ROUNDTV CARREGOU")
        print("STATUS: \(viewModel.gameService.status)")
        print("DIDALLANSWER: \(viewModel.didAllPlayersAnswer)")
        
        setupLayout()
        observeViewModel()        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
    }

    private func observeViewModel() {
        viewModel.$currentIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateCategory()
            }
            .store(in: &cancellables)
        
        viewModel.$answers
                .receive(on: DispatchQueue.main)
                .sink { [weak self] allAnswers in

                    guard let self else { return }
                    guard let currentAnswers = allAnswers[viewModel.currentCategory] else { return }
                    
                    viewModel.printAnswers()
                    
                    reloadWords(currentAnswers)
                    
                    if currentAnswers.count == viewModel.connectionManager.connectedPeers.count {
                        viewModel.didAllPlayersAnswer = true
                    }
                }
                .store(in: &cancellables)
        
        viewModel.$didAllPlayersAnswer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] didAllAnswer in
                guard let self else { return }
                if didAllAnswer {
                    self.viewModel.startVoting()
                    self.coordinator.showVoting_TV(from: self)
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

    private func updateCategory() {
        if viewModel.isFinished {
            print("view model is finished")
            textField.isHidden = true
            finishButton.isHidden = false
            categoryLabel.text = "Mostrar repostas!"
        } else {
            categoryLabel.text = viewModel.currentCategory
            textField.text = ""
        }
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

    @objc private func handleFinishButtonTapped(_ sender: UIButton) {
        for (categoria, resposta) in viewModel.answers {
            print("\(categoria): \(resposta)")
        }

        let alert = UIAlertController(title: "Concluído", message: "Respostas:\n\(viewModel.answers.map { "\($0): \($1)" }.joined(separator: "\n"))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .default))
        present(alert, animated: true)
    }

}


#Preview {
    RoundTVViewController(viewModel: RoundViewModel( connectionManager: ConnectionManager(username: "julia"), gameService: GameService()), coordinator: AppCoordinator(window: .init(), username: "newion"))
}
