//
//  LetterDrawViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//
import UIKit
import Combine


class LetterDrawViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: LetterDrawViewModel
    private let coordinator: AppCoordinator
    var gameService: GameService
    var roundVM: RoundViewModel


    private let letter: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 100, weight: .black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(viewModel: LetterDrawViewModel, coordinator: AppCoordinator, gameService: GameService, roundVM: RoundViewModel) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.gameService = gameService
        self.roundVM = roundVM
        self.letter.text = gameService.drawLetter()

        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        observeViewModel()
        roundVM.setCategories()

    }
    
    func setupUI() {
        let currentLetter = gameService.currentLetter
        view.backgroundColor = .black

        view.addSubview(letter)
        NSLayoutConstraint.activate([
            letter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            letter.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
