//
//  CategoryViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//

import UIKit
import Combine
import MultipeerConnectivity

class CategoryViewController: UIViewController {
    
    private let connectionManager: ConnectionManager
    private let gameService: GameService
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Essa é a categoria"
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    init(connectionManager: ConnectionManager, gameService: GameService) {
        self.connectionManager = connectionManager
        self.gameService = gameService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .black

        view.addSubview(descriptionLabel)
        
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
    }


}
