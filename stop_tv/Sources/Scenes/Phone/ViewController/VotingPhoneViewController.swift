//
//  VotingPhoneViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 17/06/25.
//

import UIKit
import Combine

class VotingPhoneViewController: UIViewController {
    var viewModel: RoundViewModel
    var coordinator: AppCoordinator

    private var cancellables = Set<AnyCancellable>()

    private let categoryIndicator = UILabel()
    private let answersGridView = UIView()
    private var selectedAnswerIndex: Int? = nil
    private var answerButtons: [UIButton] = []
    private let sendButtonRef = UIButton()


    init(viewModel: RoundViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        viewModel.mockAnswers()
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        observeViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()

        // mock
        let count = viewModel.answers[viewModel.currentCategory]?.count ?? 0
            updateAnswersGridView(with: count)
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
                guard status == .endVote else { return }
                self.coordinator.showAnswer_phone(from: self)
            }
            .store(in: &cancellables)
    }

    private func setupLayout() {
        let sendButton = sendButton()

        // Send button
        view.addSubview(sendButton)
        view.addSubview(answersGridView)
        answersGridView.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
//            answersGridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            answersGridView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            answersGridView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answersGridView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            answersGridView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/3),
            answersGridView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/3),


            sendButton.topAnchor.constraint(equalTo: answersGridView.bottomAnchor, constant: 24),
            sendButton.centerXAnchor.constraint(equalTo: answersGridView.centerXAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 100),

        ])

        answersGridView.layer.borderColor = UIColor.cyan.cgColor
    }

    private func updateAnswersGridView(with count: Int) {
        answersGridView.subviews.forEach { $0.removeFromSuperview() }
        answerButtons = []
        selectedAnswerIndex = nil
        setSendButton(isEnabled: false)

        let grid = UIStackView()
        grid.axis = .vertical
        grid.spacing = 8
        grid.distribution = .fillEqually
        grid.translatesAutoresizingMaskIntoConstraints = false

        let columns = 2
        let rows = Int(ceil(Double(count) / Double(columns)))
        var number = 1

        for _ in 0..<rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 8
            rowStack.distribution = .fillEqually

            for _ in 0..<columns {
                if number > count { break }

                let button = UIButton(type: .system)
                button.setTitle("\(number)", for: .normal)
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .systemBlue
                button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
                button.layer.cornerRadius = 8
                button.tag = number - 1 // 0-based index
                button.addTarget(self, action: #selector(handleAnswerTapped(_:)), for: .touchUpInside)
                button.clipsToBounds = true

                rowStack.addArrangedSubview(button)
                answerButtons.append(button)

                number += 1
            }

            grid.addArrangedSubview(rowStack)
        }

        answersGridView.addSubview(grid)

        NSLayoutConstraint.activate([
            grid.topAnchor.constraint(equalTo: answersGridView.topAnchor),
            grid.bottomAnchor.constraint(equalTo: answersGridView.bottomAnchor),
            grid.leadingAnchor.constraint(equalTo: answersGridView.leadingAnchor),
            grid.trailingAnchor.constraint(equalTo: answersGridView.trailingAnchor),
        ])
    }

    private func sendButton() -> UIButton {
        sendButtonRef.setTitle("Enviar", for: .normal)
        sendButtonRef.setTitleColor(.white, for: .normal)
        sendButtonRef.titleLabel?.font = .systemFont(ofSize: 21, weight: .medium)
        sendButtonRef.backgroundColor = .darkGray
        sendButtonRef.layer.cornerRadius = 8
        sendButtonRef.clipsToBounds = true
        sendButtonRef.addTarget(self, action: #selector(handleSendButtonTapped), for: .touchUpInside)
        sendButtonRef.isEnabled = false
        return sendButtonRef
    }

    @objc private func handleSendButtonTapped(_ sender: UIButton) {

        if let selectedAnswerIndex = selectedAnswerIndex {
            viewModel.answerIndex = selectedAnswerIndex
            viewModel.getAnswerString(from: selectedAnswerIndex)
        }

            let count = viewModel.answers[viewModel.currentCategory]?.count ?? 0
            updateAnswersGridView(with: count)
    }


    @objc private func handleAnswerTapped(_ sender: UIButton) {
        // Atualiza estado de seleção
        selectedAnswerIndex = sender.tag

        for button in answerButtons {
            if button == sender {
                button.backgroundColor = .systemGreen
            } else {
                button.backgroundColor = .systemBlue
            }
        }

        setSendButton(isEnabled: true)
    }

    private func setSendButton(isEnabled: Bool) {
        sendButtonRef.isEnabled = isEnabled
        sendButtonRef.backgroundColor = isEnabled ? .systemGreen : .darkGray
    }

}

extension VotingPhoneViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


#Preview {
    RoundPhoneViewController(viewModel: RoundViewModel( connectionManager: ConnectionManager(username: "raissa"), gameService: GameService()), coordinator: AppCoordinator(window: .init(), username: ""))
}
