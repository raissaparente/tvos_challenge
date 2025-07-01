//
//  VotingViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 17/06/25.
//
//votação, view q to fazendo
import UIKit
import Combine

class VotingTVViewController: UIViewController {
    var roundVM: RoundViewModel
    var coordinator: AppCoordinator
    var votingVM: VotingViewModel
    var letterLabel = UILabel()
    var rodadaLabel = UILabel()
    let hStack = UIStackView()
    let vStack1 = UIStackView()
    let vStack2 = UIStackView()
    
    private var cancellables = Set<AnyCancellable>()
    var matchManager: MatchManager
    // UI...
    private let containerView = UIView()
    private let categoryLabel = UILabel()
    //    private let submitButton = UIButton(type: .custom)
    private let finishButton = UIButton(type: .custom)
    private let submitButton = UIButton(type: .custom)
    
    private let stackView = UIStackView()
    
    init(viewModel: RoundViewModel, coordinator: AppCoordinator, matchManager: MatchManager,votingVM: VotingViewModel) {
        self.roundVM = viewModel
        self.coordinator = coordinator
        self.matchManager = matchManager
        self.votingVM = votingVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tava view.backgroundColor = .systemBackground e deu que nao funciona na tv ent eu mudei para .purple
        view.backgroundColor = .background
        setupLayout()
        observeViewModel()
        reloadWords()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
    }
    
    private func observeViewModel() {
        roundVM.gameService.$status
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                
                if status == .endVote {
                    
                    if roundVM.isLastCategory {
                        coordinator.showPartialRanking_TV(from: self)
                        //TODO: AVISAR PRO CELULAR IR PRA UMA TELA DE ESPERA
                    } else {
                        self.roundVM.changeCategory()
                        coordinator.showCategory_TV(from: self)
                    }
                }
                
            }
            .store(in: &cancellables)
    }
    
    private func setupLayout() {
        //hstack:
        hStack.axis = .horizontal
        hStack.distribution = .fillEqually
        hStack.spacing = 16
        hStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hStack)
        //vStack1:
        vStack1.axis = .vertical
        vStack1.spacing = 8
        vStack1.alignment = .fill
        vStack1.distribution = .fillEqually
        hStack.addArrangedSubview(vStack1)
        //vstack2:
        vStack2.axis = .vertical
        vStack2.spacing = 8
        vStack2.alignment = .fill
        vStack2.distribution = .fillEqually
        hStack.addArrangedSubview(vStack2)
        //ui: tela toda
        
        //label letra
        letterLabel.text = matchManager.currentLetter ?? ""
        letterLabel.font =  UIFont(name: "ClashDisplay-Regular.otf", size: 28)
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(letterLabel)
        
        
        //label rodada
        rodadaLabel.text = "\(matchManager.currentRound + 1)ª Rodada"
        rodadaLabel.font =  UIFont(name: "ClashDisplay-Regular.otf", size: 28)
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rodadaLabel)
        
        
        // Category label
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.font =  UIFont(name: "ClashDisplay-Semibold.otf", size:32)
        categoryLabel.text = roundVM.currentCategory
        categoryLabel.font = UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(categoryLabel)
        
        // Words
        //        stackView.axis = .vertical
        //        stackView.spacing = 12
        //        stackView.translatesAutoresizingMaskIntoConstraints = false
        //
        // Continuar button
        submitButton.setTitle("Continuar", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 21, weight: .medium)
        submitButton.backgroundColor = .customYellow
        submitButton.layer.cornerRadius = 8
        submitButton.clipsToBounds = true
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(handleEndVotingButtonTapped), for: .primaryActionTriggered)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            letterLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            letterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),

            rodadaLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            rodadaLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),

            categoryLabel.topAnchor.constraint(equalTo: letterLabel.bottomAnchor, constant: 24),
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            hStack.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 32),
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            hStack.bottomAnchor.constraint(equalTo: submitButton.topAnchor, constant: -32),

            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            submitButton.heightAnchor.constraint(equalToConstant: 60),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
        ])

    }
    
    
    //respost
    private func reloadWords() {
        //ui:
        guard let words = roundVM.answers[roundVM.currentCategory] else { return }
        
        for (index, word) in words.enumerated() {
            let fatia = FatiaView()
            fatia.configure(numero: index, texto: word.text)
            
            if index < 4 {
                vStack1.addArrangedSubview(fatia)
            } else {
                vStack2.addArrangedSubview(fatia)
            }
        }
    
     }
    
    @objc private func handleEndVotingButtonTapped(_ sender: UIButton) {
    }
}

//
//#Preview {
//    VotingTVViewController(viewModel: RoundViewModel( connectionManager: ConnectionManager(username: "julia"), gameService: GameService()), coordinator: AppCoordinator(window: .init(), username: ""), votingVM: VotingViewModel(round: RoundViewModel()))
//}
