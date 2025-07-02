//
//  LetterDrawViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//
import UIKit
import Combine
import SwiftUI
// letra
class LetterDrawViewController: UIViewController {
    // melhorar essse nomes
    
  
    let textPaperUp = UILabel()
    let textPaperDown = UILabel()
    let imageViewLetter: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    private let imagesPaper: [UIImage] = [
          UIImage(named: "Paper1")!,
          UIImage(named: "Paper2")!,
          UIImage(named: "Paper3")!,
          UIImage(named: "Paper4")!
      ]
    let imageViewPaper: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.3
        return imageView
        
    }()
    var animator: AnimationManager!
    let drawLabel = UILabel()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: LetterDrawViewModel
    private let coordinator: AppCoordinator
    var matchManager: MatchManager
    var gameService: GameService
    var roundVM: RoundViewModel

 
    private let letter: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 100, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: LetterDrawViewModel, coordinator: AppCoordinator, matchManager: MatchManager, gameService: GameService, roundVM: RoundViewModel) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.matchManager = matchManager
        self.gameService = gameService
        self.roundVM = roundVM
        
        let letter = roundVM.gameService.drawLetter()
        self.letter.text = letter
        self.matchManager.letters.append(letter)

        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let round: Int = (matchManager.currentRound + 1)
        self.setupUI()
        
        view.addSubview(textPaperUp)
        view.addSubview(textPaperDown)
        textPaperUp.translatesAutoresizingMaskIntoConstraints = false
        textPaperDown.translatesAutoresizingMaskIntoConstraints = false
        textPaperDown.isHidden = true
        textPaperUp.isHidden = true
        view.addSubview(imageViewLetter)
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        view.addSubview(imageViewPaper)
        imageViewPaper.layer.zPosition = 2
        imageViewLetter.layer.zPosition = 3
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageViewLetter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewLetter.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageViewLetter.widthAnchor.constraint(equalToConstant: 200),
            imageViewLetter.heightAnchor.constraint(equalToConstant: 200),
            imageViewPaper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewPaper.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageViewPaper.widthAnchor.constraint(equalToConstant: 500),
            imageViewPaper.heightAnchor.constraint(equalToConstant: 700),
            textPaperUp.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            textPaperDown.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -250),
            textPaperUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textPaperDown.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            drawLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            drawLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28)
            
        ])
        
        drawLabel.translatesAutoresizingMaskIntoConstraints = false
        drawLabel.text = "\(round)ª RODADA"
        drawLabel.font = UIFont(name: "ClashDisplay-Semibold", size: 40)
        view.addSubview(drawLabel)
        
        let startX = drawLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let startY = drawLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        
        
        let endX = drawLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        let endY = drawLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16)
        
        
        animator = AnimationManager(label: letter, imageViewLetter: imageViewLetter, imageViewPaper: imageViewPaper)
        animator.animateRodada(label: drawLabel,
                               in: view,
                               originalText: "\(round) Rodada",
                               startConstraints: (x: startX, y: startY),
                               endConstraints: (x: endX, y: endY)) {
            self.animator.startPaperAnimation(images: self.imagesPaper, interval: 0.5) {
                self.letter.isHidden = true
                self.imageViewLetter.isHidden = false
                self.textPaperDown.isHidden = false
                self.textPaperUp.isHidden = false
                self.animator.animate(letter: self.letter.text!) {
                    
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                        self.viewModel.canGoToCategory = true
                    }
              
                }
                
            }
        }
        self.observeViewModel()
        self.roundVM.setCategories()
    }

    func setupUI() {
        textPaperUp.text = "Sua criatividade agora\n depende da letra..."
        textPaperUp.font =  UIFont(name: "Chalkduster", size:32)
        textPaperUp.layer.zPosition = 3
        textPaperUp.textColor = .black
        textPaperUp.numberOfLines = 0
        textPaperUp.textAlignment = .center
        textPaperDown.text = "mas relaxa,qualquer coisa você inventa e\n reza pra ninguem contestar"
        textPaperDown.layer.zPosition = 3
        textPaperDown.font =  UIFont(name: "ClashDisplay-Regular", size:24)
        textPaperDown.textColor = .darkGray
        textPaperDown.numberOfLines = 0
        textPaperDown.textAlignment = .center
        backgroundImageView.layer.zPosition = 0
        view.backgroundColor =  UIColor(Color("backgroundColor", bundle: .main))
        view.addSubview(drawLabel)
        letter.layer.zPosition = 3
    }
    
    
    func observeViewModel() {
        viewModel.$canGoToCategory
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldGo in
                guard let self = self else { return }
                
                if shouldGo {
                    coordinator.showCategory_TV(from: self)
                }
            }
            .store(in: &cancellables)
    }
}

//#Preview {
//    let connectionManager = ConnectionManager(username: "julia")
//    let gameService = GameService()
//    let roundVM = RoundViewModel(connectionManager: connectionManager, gameService: gameService)
//    let cordinator = AppCoordinator(window: UIWindow(), username: "julia")
//    let viewModel = LetterDrawViewModel(connectionManager: connectionManager, gameService: gameService)
//    LetterDrawViewController(viewModel: viewModel,coordinator: cordinator, gameService: Game,roundVM: roundVM)
//}
