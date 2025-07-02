//
//  SetNameViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//

import UIKit


class SetNameViewController: UIViewController {
    
    var onNameSet: ((String) -> Void)?
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Como você quer ser chamado?"
        label.font = UIFont(name: "Clash Display", size: 20)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Digite aqui"
        textField.text = ""
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let setButton = SquareSendButton(type: .system)
    
    private var viewModel = SetNameViewModel()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        setupActions()

                // Define nome inicial aleatório
                let initialName = "Player\(Int.random(in: 100...999))"
                nameTextField.text = initialName
                viewModel.userName = initialName
                setButton.isEnabled = true
    }
    
    func setupUI() {
        view.addBackgroundView(StarsBackgroundView())
        
        setButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(descriptionLabel)
        view.addSubview(nameTextField)
        view.addSubview(setButton)
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            setButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            setButton.leadingAnchor.constraint(equalTo: nameTextField.trailingAnchor, constant: 20),
            setButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            setButton.widthAnchor.constraint(equalToConstant: 35),
            setButton.heightAnchor.constraint(equalToConstant: 35),

        ])
        
    }
    
    private func setupBindings() {
        nameTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        setButton.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        viewModel.userName = sender.text ?? ""
        setButton.isEnabled = !viewModel.userName.isEmpty
    }
    
    @objc private func setButtonTapped() {
        viewModel.saveName()
        
        onNameSet?(viewModel.userName)
    }

    private func setupActions() {
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    @objc private func textFieldChanged(_ sender: UITextField) {
            let text = sender.text ?? ""
            viewModel.userName = text
            setButton.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
        }

    @objc private func confirmButtonTapped() {
        viewModel.saveName()
        // vá para próxima tela
    }
}
