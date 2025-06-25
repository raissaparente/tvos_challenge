//
//  GameInstructionViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//


import UIKit
import Combine
import MultipeerConnectivity

class GameInstructionViewController: UIViewController {
    
    private let coordinator: AppCoordinator
    
    private let interfaceView = InstructionsView()
    
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Estamos prontos!", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
            self.view = interfaceView
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
//        setupButton()
    }
    
    func setupUI() {
        view.backgroundColor = .black

        view.addSubview(startButton)
        
        
        NSLayoutConstraint.activate([

            
            startButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 500)
        ])
    }
    private func setupButton() {
        startButton.addTarget(self, action: #selector(continueTapped), for: .primaryActionTriggered)
    }

    
    @objc private func continueTapped() {
        coordinator.showLetterDraw_TV(from: self)
    }
}
