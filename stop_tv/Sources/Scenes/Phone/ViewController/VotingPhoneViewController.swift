//
//  VotingPhoneViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 17/06/25.
//

import UIKit
import Combine

class VotingPhoneViewController: UIViewController {
    var roundVM: RoundViewModel
    var coordinator: AppCoordinator
    var votingVM: VotingViewModel

    private var cancellables = Set<AnyCancellable>()

    private let categoryIndicator = UILabel()
    private let answersGridView = UIView()
    private var selectedAnswerIndexes: Set<Int> = []
    private var answerButtons: [UIButton] = []
    private let sendButtonRef = UIButton()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Palavras em jogo"
        label.font = UIFont(name: "ClashDisplay-Semibold", size: 32)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Número tocado = palavra invalida"
        label.font = UIFont(name: "GeneralSans-Italic", size: 20)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(viewModel: RoundViewModel, coordinator: AppCoordinator, votingVM: VotingViewModel) {
        self.roundVM = viewModel
        self.coordinator = coordinator
        self.votingVM = votingVM
        super.init(nibName: nil, bundle: nil)
        observeViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // mock
        let count = roundVM.answers[roundVM.currentCategory]?.count ?? 0
        updateAnswersGridView(with: count)
        view.backgroundColor = .black
        setupLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
        votingVM.selectedAnswerIndexes.removeAll()
    }

    private func observeViewModel() {
//        roundVM.gameService.$status
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] status in
//                guard let self else { return }
//                guard status == .endVote else { return }
//                self.coordinator.showAnswer_phone(from: self)
//            }
//            .store(in: &cancellables)

        roundVM.$answers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                let count = self.roundVM.answers[self.roundVM.currentCategory]?.count ?? 0
                self.updateAnswersGridView(with: count)
            }
            .store(in: &cancellables)
    }

    private func setupLayout() {
        let sendButton = CapsuleButton.createForPhone(withTitle: "Avaliar")
        sendButton.addTarget(self, action: #selector(handleSendButtonTapped), for: .touchUpInside)
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        
        let contentStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, answersGridView, sendButton])
        contentStack.axis = .vertical
        contentStack.spacing = 60
        contentStack.alignment = .center
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        contentStack.setCustomSpacing(4, after: titleLabel)
        view.addSubview(contentStack)
        

        answersGridView.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            answersGridView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            answersGridView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.5),

            titleLabel.widthAnchor.constraint(equalTo: contentStack.widthAnchor),
            subtitleLabel.widthAnchor.constraint(equalTo: contentStack.widthAnchor),
            sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
        
        let bg = UIImageView(image: UIImage(named: "paperTexture"))
        bg.contentMode = .scaleAspectFill
        bg.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(bg, at: 0)
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: view.topAnchor),
            bg.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bg.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func updateAnswersGridView(with count: Int) {
        answersGridView.subviews.forEach { $0.removeFromSuperview() }
        answerButtons = []
        selectedAnswerIndexes = []

        let grid = UIStackView()
        grid.axis = .vertical
        grid.spacing = 8
        grid.distribution = .fillEqually
        grid.translatesAutoresizingMaskIntoConstraints = false

        let columns = 3
        let rows = Int(ceil(Double(count) / Double(columns)))
        var number = 1

        for row in 0..<rows {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 16
                rowStack.alignment = .center
                rowStack.distribution = .fillProportionally
            rowStack.translatesAutoresizingMaskIntoConstraints = false

                let remaining = count - number + 1
                let itemsInThisRow = min(columns, remaining)
            
            let centeringContainer = UIView()
            centeringContainer.translatesAutoresizingMaskIntoConstraints = false
            centeringContainer.addSubview(rowStack)

            NSLayoutConstraint.activate([
                rowStack.centerXAnchor.constraint(equalTo: centeringContainer.centerXAnchor),
                rowStack.topAnchor.constraint(equalTo: centeringContainer.topAnchor),
                rowStack.bottomAnchor.constraint(equalTo: centeringContainer.bottomAnchor)
            ])

                for _ in 0..<itemsInThisRow {
                    let button = CircleButton.create(withTitle: "\(number)")
                    button.tag = number - 1
                    button.addTarget(self, action: #selector(handleGridTapped(_:)), for: .touchUpInside)

                    button.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        button.widthAnchor.constraint(equalToConstant: 80),
                        button.heightAnchor.constraint(equalTo: button.widthAnchor)
                    ])

                    rowStack.addArrangedSubview(button)
                    answerButtons.append(button)
                    number += 1
                }

            grid.addArrangedSubview(centeringContainer)
        }

        answersGridView.addSubview(grid)

        NSLayoutConstraint.activate([
            grid.topAnchor.constraint(equalTo: answersGridView.topAnchor),
            grid.bottomAnchor.constraint(equalTo: answersGridView.bottomAnchor),
            grid.leadingAnchor.constraint(equalTo: answersGridView.leadingAnchor),
            grid.trailingAnchor.constraint(equalTo: answersGridView.trailingAnchor),
        ])
    }

    @objc private func handleSendButtonTapped(_ sender: UIButton) {
        let count = roundVM.answers[roundVM.currentCategory]?.count ?? 0
        let selected = selectedAnswerIndexes

        votingVM.selectedAnswerIndexes = selected
        votingVM.sendVote()

        updateAnswersGridView(with: count)
        
        exitLocalVoting()
    }


    @objc private func handleGridTapped(_ sender: UIButton) {

        let index = sender.tag

        if selectedAnswerIndexes.contains(index) {
            selectedAnswerIndexes.remove(index)
            sender.backgroundColor = .customPink
        } else {
            selectedAnswerIndexes.insert(index)
            sender.backgroundColor = .systemGreen
        }
    }
    
    private func exitLocalVoting() {
        coordinator.showWaitingMessage_phone(from: self, type: .waitingForEndVote)
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
