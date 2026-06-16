//
//  PartialRankingViewController.swift
//  stop_tv
//
//  Created by Raissa Parente on 23/06/25.
//

import UIKit
import MultipeerConnectivity
import StopPlay

class PartialRankingViewController: UIViewController {

    var coordinator: AppCoordinator
    var viewModel: RoundViewModel
    var matchManager: MatchManager

    private var rankedPlayers: [(rank: Int, player: Player)] = []

    private let backgroundView = StarsBackgroundTVView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ranking da Rodada"
        label.font = UIFont(name: "ClashDisplay-Semibold", size: 40) ?? .boldSystemFont(ofSize: 40)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fill
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let continueButton: CapsuleButton = {
        let button = CapsuleButton.createForTV(withTitle: "Continuar")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    init(coordinator: AppCoordinator, viewModel: RoundViewModel, matchManager: MatchManager) {
        self.coordinator = coordinator
        self.viewModel = viewModel
           self.matchManager = matchManager
           super.init(nibName: nil, bundle: nil)
       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRankedPlayers()
        setupLayout()
        setupCards()
        setupButton()
    }

    private func setupRankedPlayers() {
        let sorted = matchManager.players.sorted { $0.points > $1.points }
        rankedPlayers = sorted.enumerated().map { (index, player) in
            (rank: index + 1, player: player)
        }
    }

    private func setupLayout() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundView)
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        view.addSubview(continueButton)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 120),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -120),
            scrollView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }

    private func setupCards() {
        for (rank, player) in rankedPlayers {
            let card = RankingPlayerCardView()
            card.configure(rank: rank, name: player.name, points: player.points, isTop: rank <= 3)
            stackView.addArrangedSubview(card)
        }
    }

    func setupButton() {
        continueButton.addTarget(self, action: #selector(continueTapped), for: .primaryActionTriggered)
    }

    @objc private func continueTapped() {
        matchManager.finishRound()
        viewModel.reset()

        if matchManager.isGameFinished {
            coordinator.showFinalRanking_TV(from: self)
        } else {
            coordinator.showLetterDraw_TV(from: self)
        }
    }
}
