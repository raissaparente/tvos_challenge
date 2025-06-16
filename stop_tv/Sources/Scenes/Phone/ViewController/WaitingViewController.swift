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
    
    private let statusLabel = UILabel()

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
        view.backgroundColor = .white
        statusLabel.text = viewModel.waitingText
        statusLabel.textAlignment = .center
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
