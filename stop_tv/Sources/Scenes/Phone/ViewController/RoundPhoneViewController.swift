//
//  RoundTestViewController.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//

import UIKit
import Combine

class RoundPhoneViewController: UIViewController {
    var viewModel: RoundViewModel
    var coordinator: AppCoordinator
    private var cancellables = Set<AnyCancellable>()


    private let containerView = UIView()
    private let textField = UITextField()
    private let categoryLabel = UILabel()
    private let submitButton = UIButton(type: .custom)

    init(viewModel: RoundViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        textField.delegate = self
        print(self, #function)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
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
        ])
    }
    
    func observeViewModel() {
        viewModel.gameService.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self = self else { return }
            
                print("📱 Mudou o status do jogo no celular: \(status)")
                guard status == .startVote else { return }
                coordinator.showVoting_phone(from: self)
                
            }
            .store(in: &cancellables)
    }

    private func updateCategory() {
        if viewModel.isFinished {
            textField.isHidden = true
            submitButton.isHidden = true
            categoryLabel.text = "Mostrar repostas!"
        } else {
            categoryLabel.text = viewModel.currentCategory
            print("🖥️ Mostrando nova categoria na TV: \(viewModel.currentCategory)")
            textField.text = ""
        }
    }

    @objc private func handleSubmitButtonTapped(_ sender: UIButton) {
        viewModel.saveAnswer(textField.text ?? "")
        viewModel.sendAnswer(textField.text ?? "")
    }
}

extension RoundPhoneViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


#Preview {
    RoundPhoneViewController(viewModel: RoundViewModel( connectionManager: ConnectionManager(username: "raissa"), gameService: GameService()), coordinator: AppCoordinator(window: .init(), username: ""))
}
