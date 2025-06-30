//
//  PostitAlertView.swift
//  stop_tv
//
//  Created by Raissa Parente on 29/06/25.
//
import UIKit

final class PostitAlertView: UIView {
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "scribbledPostit"))
        image.contentMode = .scaleAspectFit

        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Convite recebido."
        label.font = UIFont(name: "ClashDisplay-Regular", size: 24)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Só falta aceitar."
        label.font = UIFont(name: "GeneralSans-Italic", size: 20)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let acceptButton = CapsuleButton.createForPhone(withTitle: "Aceitar")
    let refuseButton = CapsuleButton.createForPhone(withTitle: "Recusar")
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
        
        setupButtons()

        
        container.insertSubview(imageView, at: 0)
        container.addSubview(titleLabel)
        container.addSubview(subtitleLabel)
        container.addSubview(buttonStack)


        addSubview(container)
                
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),

            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: container.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
            
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -40),

            subtitleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),

            buttonStack.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            buttonStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            buttonStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        let bg = UIImageView(image: UIImage(named: "paperTexture"))
        bg.contentMode = .scaleAspectFill
        bg.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(bg, at: 0)
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: topAnchor),
            bg.bottomAnchor.constraint(equalTo: bottomAnchor),
            bg.leadingAnchor.constraint(equalTo: leadingAnchor),
            bg.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupButtons() {
        refuseButton.normalColor = .lightGray
        
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        refuseButton.translatesAutoresizingMaskIntoConstraints = false

        buttonStack.addArrangedSubview(refuseButton)
        buttonStack.addArrangedSubview(acceptButton)
    }
    
//    @objc private func acceptDummy() {}
//    
//    @objc private func refuseDummy() {}

}
