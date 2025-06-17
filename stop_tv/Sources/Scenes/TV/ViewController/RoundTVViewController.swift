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
    private var cancellables = Set<AnyCancellable>()

    // UI...
    private let containerView = UIView()
    private let textField = UITextField()
    private let categoryLabel = UILabel()
//    private let submitButton = UIButton(type: .custom)
    private let finishButton = UIButton(type: .custom)

    init(viewModel: RoundViewModel) {
        self.viewModel = viewModel
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
    }

    private func observeViewModel() {
        viewModel.$currentIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("esse observe da tv funciona?")
                self?.updateCategory()
                print("ele passa do self opctional")

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

        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            categoryLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),

        ])
    }

    private func updateCategory() {
        if viewModel.isFinished {
            print("view model is finished")
            textField.isHidden = true
            finishButton.isHidden = false
            categoryLabel.text = "Mostrar repostas!"
        } else {
            print("deveria mostrar")
            categoryLabel.text = viewModel.currentCategory
            textField.text = ""
            print("mostrou categoria\(viewModel.currentCategory)")
        }
    }

    @objc private func handleFinishButtonTapped(_ sender: UIButton) {
        print("Respostas do usuário:")
        for (categoria, resposta) in viewModel.answers {
            print("\(categoria): \(resposta)")
        }

        let alert = UIAlertController(title: "Concluído", message: "Respostas:\n\(viewModel.answers.map { "\($0): \($1)" }.joined(separator: "\n"))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .default))
        present(alert, animated: true)
    }
}


#Preview {
    RoundTVViewController(viewModel: RoundViewModel( connectionManager: ConnectionManager(username: "julia"), gameService: GameService()))
}
