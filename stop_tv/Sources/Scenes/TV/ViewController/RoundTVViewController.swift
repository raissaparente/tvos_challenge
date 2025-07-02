//
//  RoundTestViewController.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//
//categorias

import UIKit
import Combine
import SwiftUICore
import StopPlay

class RoundTVViewController: UIViewController {
    var viewModel: RoundViewModel
    var matchManager: MatchManager
    var coordinator: AppCoordinator
    var animator: AnimationManager!
    var letterLabel = UILabel()
    let drawLabel = UILabel()
    private var cancellables = Set<AnyCancellable>()
    
    let playersView = ConnectedPlayersView()

    private let letter: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 100, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let imagesCard: [UIImage] = [
          UIImage(named: "Card1")!,
          UIImage(named: "Card2")!,
          UIImage(named: "Card3")!,
          UIImage(named: "Card4")!
      ]
    let imageViewCard: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    var categoriesAnimate: [String] {
        viewModel.categories
    }
    // UI...
    private let containerView = UIView()
    private let textField = UITextField()
    private let categoryLabel = UILabel()
    private let finishButton = UIButton(type: .custom)
    private let stackView = UIStackView()


    init(viewModel: RoundViewModel,matchManager:MatchManager, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.matchManager = matchManager
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("VDL ROUND TV")
        view.addSubview(imageViewCard)
        NSLayoutConstraint.activate([
            imageViewCard.topAnchor.constraint(equalTo: view.topAnchor),
            imageViewCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewCard.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageViewCard.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        view.backgroundColor = .black
        setupLayout()
        view.backgroundColor =  UIColor(Color("backgroundColor", bundle: .main))
        animator = AnimationManager(label: categoryLabel, imageViewPaper: imageViewCard)
        animator.startPaperAnimation(images: imagesCard) {
            self.categoryLabel.isHidden = false
        }
        
        observeViewModel()        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
    }

    private func observeViewModel() {
        viewModel.$currentIndex
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateCategory()
            }
            .store(in: &cancellables)
        
        viewModel.$answers
                .receive(on: DispatchQueue.main)
                .sink { [weak self] allAnswers in

                    guard let self else { return }
                    guard let currentAnswers = allAnswers[viewModel.currentCategory] else { return }
                    
                    let playersWhoAnswered = currentAnswers.enumerated().map { index, _ in
                        String(format: "Jogador %02d", index + 1)
                    }
                    
//                    let playersWhoAnswered = currentAnswers.map(\.name)
                    playersView.reloadPlayers(from: playersWhoAnswered)
                    
                    if currentAnswers.count == viewModel.connectionManager.connectedPeers.count {
                        viewModel.didAllPlayersAnswer = true
                    }
                }
                .store(in: &cancellables)
        
        viewModel.$didAllPlayersAnswer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] didAllAnswer in
                guard let self else { return }
                if didAllAnswer {
                    self.viewModel.startVoting()
                    self.coordinator.showVoting_TV(from: self)
                }
            }
            .store(in: &cancellables)
    }

    private func setupLayout() {
        //add letra
        view.addSubview(letter)
        //aqui eu coloco a letra que foi sorteada pegando da viewmodel
        letter.text = "Letra \(matchManager.currentLetter ?? "")"
        letter.font =  UIFont(name: "ClashDisplay-Semibold", size: 40)
        letter.translatesAutoresizingMaskIntoConstraints = false
        
        //add palavra rodada
        drawLabel.text = "\(matchManager.currentRound + 1)ª RODADA"
        drawLabel.font =  UIFont(name: "ClashDisplay-Semibold", size: 40)
        drawLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawLabel)

        // Category label
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.font =  UIFont(name: "AnonymousPro-Bold", size: 50)
        categoryLabel.textColor = .black
        categoryLabel.numberOfLines = 0
        categoryLabel.layer.zPosition = 3
        view.addSubview(categoryLabel)
        categoryLabel.isHidden = true
        
        //Players who answered
        playersView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playersView)
        
        NSLayoutConstraint.activate([
            letter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            letter.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            
            drawLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            drawLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),

            categoryLabel.centerXAnchor.constraint(equalTo: imageViewCard.centerXAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: imageViewCard.centerYAnchor, constant: -170),
            
            playersView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            playersView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    private func updateCategory() {
        if viewModel.isFinished {
            textField.isHidden = true
            finishButton.isHidden = false
            categoryLabel.text = "Mostrar repostas!"
        } else {
            categoryLabel.text = viewModel.currentCategory
            textField.text = ""
            animator.animate(letter: viewModel.currentCategory)
        }
    }
    

    @objc private func handleFinishButtonTapped(_ sender: UIButton) {
        for (categoria, resposta) in viewModel.answers {
            print("\(categoria): \(resposta)")
        }

        let alert = UIAlertController(title: "Concluído", message: "Respostas:\n\(viewModel.answers.map { "\($0): \($1)" }.joined(separator: "\n"))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Fechar", style: .default))
        present(alert, animated: true)
    }

}

