//
//  ConnectedPlayersView.swift
//  stop_tv
//
//  Created by Raissa Parente on 25/06/25.
//
import UIKit

final class ConnectedPlayersView: UIView {
    
    let testNames = ["Raissa", "Beyanca", "Julia Saboya", "Plutarco"]

    let postitStack = UIStackView()
    let inviteButton = CapsuleButton.create(withTitle: "Continuar", target: nil, action: #selector(dummy))

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupViews()
        
        reloadPlayers(from: testNames)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let titleLabel = UILabel()
        titleLabel.text = "Falta alguém?"
        titleLabel.font = UIFont(name: "ClashDisplay-Semibold", size: 50)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0

        //POSTITS
        postitStack.axis = .horizontal
        postitStack.spacing = 20
        postitStack.alignment = .center
        postitStack.distribution = .fill

        //BOTAO
        let buttonWrapper = UIView()
          buttonWrapper.translatesAutoresizingMaskIntoConstraints = false
          inviteButton.translatesAutoresizingMaskIntoConstraints = false
          buttonWrapper.addSubview(inviteButton)
          
          NSLayoutConstraint.activate([
              inviteButton.topAnchor.constraint(equalTo: buttonWrapper.topAnchor),
              inviteButton.bottomAnchor.constraint(equalTo: buttonWrapper.bottomAnchor),
              inviteButton.trailingAnchor.constraint(equalTo: buttonWrapper.trailingAnchor)
          ])
 
        //TUDO
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            postitStack,
            buttonWrapper
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            buttonWrapper.widthAnchor.constraint(equalTo: stack.widthAnchor)
        ])
    }
    
    func reloadPlayers(from names: [String]) {
        postitStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for name in names {
            let postit = makePlayerPostit(name: name)
            postitStack.addArrangedSubview(postit)
        }
    }

    
    private func makePlayerPostit(name: String) -> UIView {
        let size = 200.0
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: size).isActive = true
        view.heightAnchor.constraint(equalToConstant: size).isActive = true
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        let postitImage = UIImageView(image: UIImage(named: "postit"))
        postitImage.contentMode = .scaleAspectFill
        postitImage.translatesAutoresizingMaskIntoConstraints = false
        postitImage.widthAnchor.constraint(equalToConstant: size).isActive = true
        postitImage.heightAnchor.constraint(equalToConstant: size).isActive = true

        let text = UILabel()
        text.text = name
        text.font = UIFont(name: "Chalkduster", size: 30)
        text.textColor = .black
        text.textAlignment = .center
        text.numberOfLines = 0

        text.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(postitImage)
        view.addSubview(text)
        
        NSLayoutConstraint.activate([
            postitImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            postitImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            text.centerYAnchor.constraint(equalTo: postitImage.centerYAnchor),
            text.centerXAnchor.constraint(equalTo: postitImage.centerXAnchor),
            text.widthAnchor.constraint(lessThanOrEqualTo: postitImage.widthAnchor, constant: -16)
        ])
        
        return view
    }

    @objc private func dummy() {}
}
