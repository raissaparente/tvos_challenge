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
          UIImage(named: "Papel1")!,
          UIImage(named: "Papel2")!,
          UIImage(named: "Papel3")!,
          UIImage(named: "Papel4")!
      ]
    let imageViewPaper: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
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
        self.roundVM.currentLetter = letter
        if self.matchManager.letters.indices.contains(self.matchManager.currentRound) {
            self.matchManager.letters[self.matchManager.currentRound] = letter
        } else {
            self.matchManager.letters.append(letter)
        }

        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.animate()

        self.observeViewModel()
        self.roundVM.setCategories()
    }

    func setupUI() {
        let currentRound: Int = (matchManager.currentRound + 1)

        textPaperUp.text = "Sua criatividade agora\n depende da letra..."
        textPaperUp.font =  UIFont(name: "Chalkduster", size:32)
        textPaperUp.layer.zPosition = 3
        textPaperUp.textColor = .black
        textPaperUp.numberOfLines = 0
        textPaperUp.textAlignment = .center
        textPaperUp.translatesAutoresizingMaskIntoConstraints = false
        textPaperUp.isHidden = true
        
        textPaperDown.text = "mas relaxa, qualquer coisa você inventa e\n reza pra ninguem contestar"
        textPaperDown.layer.zPosition = 3
        textPaperDown.font =  UIFont(name: "ClashDisplay-Regular", size:24)
        textPaperDown.textColor = .darkGray
        textPaperDown.numberOfLines = 0
        textPaperDown.textAlignment = .center
        textPaperDown.translatesAutoresizingMaskIntoConstraints = false
        textPaperDown.isHidden = true
        
        view.backgroundColor =  .black
        view.addSubview(drawLabel)
        letter.layer.zPosition = 3
        
        view.addSubview(textPaperUp)
        view.addSubview(textPaperDown)
        view.addSubview(imageViewLetter)
        view.addSubview(imageViewPaper)
        
        imageViewPaper.layer.zPosition = 2
        imageViewLetter.layer.zPosition = 3
        
        NSLayoutConstraint.activate([
            imageViewLetter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewLetter.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageViewLetter.widthAnchor.constraint(equalToConstant: 250),
            imageViewLetter.heightAnchor.constraint(equalToConstant: 250),
            
            imageViewPaper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageViewPaper.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageViewPaper.widthAnchor.constraint(equalToConstant: 600),
            imageViewPaper.heightAnchor.constraint(equalToConstant: 700),
            
            textPaperUp.bottomAnchor.constraint(equalTo: imageViewLetter.topAnchor, constant: 20),
            textPaperUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            textPaperDown.topAnchor.constraint(equalTo: imageViewLetter.bottomAnchor, constant: -20),
            textPaperDown.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            drawLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            drawLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
        ])
        
        drawLabel.translatesAutoresizingMaskIntoConstraints = false
        drawLabel.isHidden = true
        drawLabel.text = "\(currentRound)ª RODADA"
        drawLabel.font = UIFont(name: "ClashDisplay-Semibold", size: 40)
        view.addSubview(drawLabel)
        
        //Background
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
    
    func animate() {
        let currentRound: Int = (matchManager.currentRound + 1)
        
        animator = AnimationManager(label: letter, imageViewLetter: imageViewLetter, imageViewPaper: imageViewPaper)
        
        //ANIMACAO DA PALAVRA RODADA
        animator.animateRodadaSlotStyle(word: "\(currentRound) RODADA", in: self.view) {
            
            //ANIMACAO DO PAPEL ABRINDO
            self.animator.startPaperAnimation(images: self.imagesPaper, interval: 0.5) {
                self.letter.isHidden = true
                self.drawLabel.isHidden = false
                self.imageViewLetter.isHidden = false
                self.textPaperDown.isHidden = false
                self.textPaperUp.isHidden = false
                
                //ANIMACAO DAS LETRAS DO ALFABETO
                self.animator.animate(letter: self.letter.text!) {
                    
                    //PASSA PRA VIEW DA CATEGORIA
                    self.viewModel.canGoToCategory = true
                }
            }
        }
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
