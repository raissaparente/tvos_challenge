//
//  WaitingViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//

import UIKit
import Combine


class WaitingViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    private let viewModel: WaitingViewModel
    private let coordinator: AppCoordinator
    
    private let image: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 100)
        let image = UIImageView(image: UIImage(systemName: "sparkles.tv", withConfiguration: configuration))
        image.tintColor = .systemYellow
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Atenção na tela grande!"
        label.font = UIFont(name: "ClashDisplay-Regular", size: 24)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(viewModel: WaitingViewModel, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        observeViewModel()
    }
    
    func setupUI() {
        view.backgroundColor = .black

        view.addSubview(image)
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20)
        ])
        
        
        //bg
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
    
    //navega
    private func observeViewModel() {
        viewModel.$didFinishWaiting
            .filter { $0 }
            .sink { [weak self] _ in
                self?.handleWaitingCompleted()
            }
            .store(in: &cancellables)
    }

    private func handleWaitingCompleted() {
        switch viewModel.waitingType {
        case .explaining:
            coordinator.showAnswer_phone(from: self)
            
            // outros tipos de espera, se forem adicionados no futuro
        }
    }
}
