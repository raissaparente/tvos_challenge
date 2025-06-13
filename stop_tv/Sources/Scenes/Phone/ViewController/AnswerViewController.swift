//
//  AnswerViewController.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//



import UIKit
import Combine
import MultipeerConnectivity

class AnswerViewController: UIViewController {
    
    private let viewModel: AnswerViewModel
    private let coordinator: AppCoordinator
    
    private let answerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Resposta"
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
        
    init(viewModel: AnswerViewModel, coordinator: AppCoordinator) {
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
        setupBindings()
    }
    
    func setupUI() {
        view.backgroundColor = .white

        [answerTextField, setButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            answerTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            answerTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            answerTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            setButton.topAnchor.constraint(equalTo: answerTextField.bottomAnchor, constant: 20),
            setButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    
    private func setupBindings() {
        answerTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        setButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        viewModel.answer = sender.text ?? ""
        setButton.isEnabled = !viewModel.answer.isEmpty
    }
    
    @objc private func sendButtonTapped() {
        viewModel.sendAnswer()
    }
}
