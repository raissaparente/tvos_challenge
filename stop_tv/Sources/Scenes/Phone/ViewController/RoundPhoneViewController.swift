//
//  RoundTestViewController.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//

import UIKit

class RoundPhoneViewController: UIViewController {
    var viewModel: RoundViewModel

    private let containerView = UIView()
    private let textField = UITextField()
    private let categoryLabel = UILabel()
    private let submitButton = UIButton(type: .custom)
    private let finishButton = UIButton(type: .custom)

    init(viewModel: RoundViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        textField.delegate = self

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                view.backgroundColor = .systemBackground
                setupLayout()
                updateCategory()
    }

    private func setupLayout() {
        // Container setup
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .lightGray
        containerView.layer.cornerRadius = 12
        view.addSubview(containerView)

        // TextField
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        containerView.addSubview(textField)

        // Submit button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 21, weight: .medium)
        submitButton.backgroundColor = .darkGray
        submitButton.layer.cornerRadius = 8
        submitButton.clipsToBounds = true
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(handleSubmitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)

        // Finish button (oculto inicialmente)
        finishButton.setTitle("Finalizar", for: .normal)
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.titleLabel?.font = .systemFont(ofSize: 21, weight: .medium)
        finishButton.backgroundColor = .systemBlue
        finishButton.layer.cornerRadius = 8
        finishButton.clipsToBounds = true
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.addTarget(self, action: #selector(handleFinishButtonTapped), for: .touchUpInside)
        finishButton.isHidden = true
        view.addSubview(finishButton)

        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            textField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            submitButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            submitButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 100),

            finishButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishButton.widthAnchor.constraint(equalToConstant: 140),
        ])
    }

    private func updateCategory() {
        if viewModel.isFinished {
            textField.isHidden = true
            submitButton.isHidden = true
            finishButton.isHidden = false
            categoryLabel.text = "Mostrar repostas!"
        } else {
            categoryLabel.text = viewModel.currentCategory
            print("🖥️ Mostrando nova categoria na TV: \(categoryLabel.text ?? "undefined")")
            textField.text = ""
        }
    }

    @objc private func handleSubmitButtonTapped(_ sender: UIButton) {
        viewModel.saveAnswer(textField.text ?? "")
        viewModel.sendAnswer()

        updateCategory()
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

extension RoundPhoneViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


#Preview {
    RoundPhoneViewController(viewModel: RoundViewModel( connectionManager: ConnectionManager(username: "raissa"), gameService: GameService()))
}
