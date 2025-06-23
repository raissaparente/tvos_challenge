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
        label.text = "Escolha um nome para você"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Seu nome"
        textField.text = ""
        textField.borderStyle = .roundedRect
        return textField
    }()

    private let setButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirmar", for: .normal)
        button.isEnabled = false
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        return button
    }()
    
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
        view.backgroundColor = .white

        [descriptionLabel, nameTextField, setButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            setButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            setButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setButton.widthAnchor.constraint(equalToConstant: 100)
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
