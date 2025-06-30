//
//  VotingViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 17/06/25.
//
//votação
import UIKit
import Combine

class VotingTVViewController: UIViewController {
    var viewModel: RoundViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // UI...
    private let containerView = UIView()
    private let textField = UITextField()
    private let categoryLabel = UILabel()
    //    private let submitButton = UIButton(type: .custom)
    private let finishButton = UIButton(type: .custom)
    private let submitButton = UIButton(type: .custom)
    
    private let stackView = UIStackView()
    
    
    init(viewModel: RoundViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tava view.backgroundColor = .systemBackground e deu que nao funciona na tv ent eu mudei para .purple
        view.backgroundColor = .purple
        setupLayout()
        observeViewModel()
        reloadWords()
        
    }
    
    private func observeViewModel() {
        
        viewModel.$didAllPlayersVote
            .receive(on: DispatchQueue.main)
            .sink { [weak self] didAllVote in
                if didAllVote {
                    self?.viewModel.changeCategory()
                }
                
            }
            .store(in: &cancellables)
    }
    
    private func setupLayout() {
        //ui: tela toda
        
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
            
            submitButton.topAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.topAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
        ])
    }
    
    
    
    private func reloadWords() {
        //ui:
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
        viewModel.didAllPlayersVote = true
    }
}


#Preview {
    VotingTVViewController(viewModel: RoundViewModel( connectionManager: ConnectionManager(username: "julia"), gameService: GameService()))
}
