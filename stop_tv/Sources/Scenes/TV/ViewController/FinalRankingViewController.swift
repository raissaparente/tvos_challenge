//
//  FinalRankingViewController.swift
//  stop_tv
//
//  Created by Raissa Parente on 23/06/25.
//

import UIKit
import MultipeerConnectivity
import StopPlay

class FinalRankingViewController: UIViewController, UITableViewDataSource {
    
    let mockplayers = [Player(name: "Raissa", points: 50),
                   Player(name: "Plutarco", points: 100),
//                   Player(name: "Julia", points: 20),
//                   Player(name: "Bey", points: 150)
    ]
    
    var coordinator: AppCoordinator
    var viewModel: RoundViewModel
    var matchManager: MatchManager
    
    private let titleLabel1: UILabel = {
        let label = UILabel()
        label.text = "Ranking"
        label.font = UIFont(name: "ClashDisplay-Semibold", size: 50)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel2: UILabel = {
        let label = UILabel()
        label.text = "Final"
        label.font = UIFont(name: "ClashDisplay-Semibold", size: 80)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let podiumStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .bottom
        stack.distribution = .equalSpacing
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private let tableView = UITableView()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Jogar de Novo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
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
        view.backgroundColor = .black

        setupLayout()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        view.addBackgroundView(StarsBackgroundView())

        let titleContainer = setupTitle()
        setupPodium()
        let buttonContainer = createYesNoContainer(target: self, yesAction: #selector(yesAction), noAction: #selector(noAction))
        
        view.addSubview(titleContainer)
        view.addSubview(podiumStack)
        view.addSubview(buttonContainer)
//        view.addSubview(tableView)
//        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            titleContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            podiumStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            podiumStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
//            tableView.topAnchor.constraint(equalTo: podiumStack.bottomAnchor, constant: 12),
//            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            
            buttonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            buttonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            buttonContainer.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setupTitle() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel1)
        container.addSubview(titleLabel2)
        
        NSLayoutConstraint.activate([
            titleLabel1.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel1.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel1.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            titleLabel2.topAnchor.constraint(equalTo: titleLabel1.bottomAnchor),
            titleLabel2.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel2.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            titleLabel2.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        
        return container
    }
    
    func setupPodium() {
        let topThree = getTopThree(from: mockplayers)
           let podiumOrder = [1, 0, 2]

           let verticalOffsets: [CGFloat] = [100, 0, 100]

           for (index, place) in podiumOrder.enumerated() {
               let player = topThree[place]
               let offset = verticalOffsets[index]
               let height = 250.0

               let container = UIView()
               container.widthAnchor.constraint(equalToConstant: 200).isActive = true
               container.translatesAutoresizingMaskIntoConstraints = false

               let podiumView = PodiumPlayerView(player: player, place: place + 1)
               podiumView.translatesAutoresizingMaskIntoConstraints = false

               container.addSubview(podiumView)
               podiumStack.addArrangedSubview(container)

               NSLayoutConstraint.activate([
                   podiumView.topAnchor.constraint(equalTo: container.topAnchor, constant: offset),
                   podiumView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                   podiumView.heightAnchor.constraint(equalToConstant: height),
                   podiumView.widthAnchor.constraint(equalToConstant: 200)
               ])
           }
    }
    
    func createYesNoContainer(target: Any?, yesAction: Selector, noAction: Selector) -> UIView {
        let questionLabel = UILabel()
        questionLabel.text = "Revanche?"
        questionLabel.textColor = .white
        questionLabel.font = UIFont(name: "ClashDisplay-Regular", size: 50)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false

        let yesButton = CapsuleButton.createForTV(withTitle: "Sim")
        let noButton = CapsuleButton.createForTV(withTitle: "Não")
        
        yesButton.addTarget(target, action: yesAction, for: .primaryActionTriggered)
        noButton.addTarget(target, action: noAction, for: .primaryActionTriggered)
        yesButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        noButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        NSLayoutConstraint.activate([
            yesButton.widthAnchor.constraint(equalToConstant: 120),
            noButton.widthAnchor.constraint(equalToConstant: 120),
            yesButton.heightAnchor.constraint(equalToConstant: 80),
            noButton.heightAnchor.constraint(equalToConstant: 80)
        ])

        let buttonStack = UIStackView(arrangedSubviews: [yesButton, noButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.alignment = .center
        buttonStack.distribution = .equalSpacing
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        let verticalStack = UIStackView(arrangedSubviews: [questionLabel, buttonStack])
        verticalStack.axis = .vertical
        verticalStack.spacing = 20
        verticalStack.alignment = .fill
        verticalStack.translatesAutoresizingMaskIntoConstraints = false

        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(verticalStack)


        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: container.topAnchor),
            verticalStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            questionLabel.widthAnchor.constraint(equalTo: verticalStack.widthAnchor),
        ])

        return container
    }

    
    
    @objc private func yesAction() {
        matchManager.resetGame()
        viewModel.reset()
        
        //TODO: NAVEGAR PRA ONDE?
    }
    
    @objc private func noAction() {
        matchManager.resetGame()
        viewModel.reset()
        
        //TODO: NAVEGAR PRA ONDE?
    }
    
    func getTopThree(from players: [Player]) -> [Player?] {
        var top: [Player?] = Array(players.sorted { $0.points > $1.points }.prefix(3))
        while top.count < 3 {
            top.append(nil)
        }
        return top
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchManager.players.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let players = viewModel.gameService.makeRanking(from: matchManager.players)
        
        let player =  players[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = player.name
        return cell
    }
}
