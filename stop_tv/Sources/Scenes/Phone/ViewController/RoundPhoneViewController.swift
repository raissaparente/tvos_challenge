//
//  RoundTestViewController.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//

import UIKit
import Combine

class RoundPhoneViewController: UIViewController {
    var roundVM: RoundViewModel
    var coordinator: AppCoordinator
    private var cancellables = Set<AnyCancellable>()
    
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Categoria + letra = sua palavra"
        label.font = UIFont(name: "Clash Display", size: 20)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textfield: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Digite aqui"
        textField.text = ""
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let submitButton = SquareSendButton(type: .system)
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Deu branco?"
        label.font = UIFont(name: "Clash Display", size: 15)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pular a vez", for: .normal)
        button.titleLabel?.font = UIFont(name: "Clash Display", size: 17)!
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(viewModel: RoundViewModel, coordinator: AppCoordinator) {
        self.roundVM = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        textfield.delegate = self
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
        view.backgroundColor = .black
        setupUI()
    }
    
    func setupUI() {
        view.addBackgroundView(StarsBackgroundView())
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(handleSubmitButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(handleSkipButtonTapped), for: .touchUpInside)
        
        view.addSubview(descriptionLabel)
        view.addSubview(textfield)
        view.addSubview(submitButton)
        view.addSubview(subtitleLabel)
        view.addSubview(skipButton)
    
        NSLayoutConstraint.activate([
            descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            textfield.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            submitButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            submitButton.leadingAnchor.constraint(equalTo: textfield.trailingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.widthAnchor.constraint(equalToConstant: 35),
            submitButton.heightAnchor.constraint(equalToConstant: 35),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: 20),
            
            skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            skipButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor),
        ])
        
    }
    
    
    @objc private func handleSubmitButtonTapped(_ sender: UIButton) {
        let answer = roundVM.createAnswer(text: textfield.text ?? "")
        roundVM.saveAnswer(answer)
        roundVM.sendAnswer(answer)
        
        coordinator.showWaitingMessage_phone(from: self, type: .waitingForAnswers)
    }
    
    @objc private func handleSkipButtonTapped(_ sender: UIButton) {
        let answer = roundVM.createAnswer(text: "")
        roundVM.saveAnswer(answer)
        roundVM.sendAnswer(answer)
        
        coordinator.showWaitingMessage_phone(from: self, type: .waitingForAnswers)

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
