//
//  InstructionsView.swift
//  stop_tv
//
//  Created by Raissa Parente on 25/06/25.
//
import UIKit

final class InstructionsView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let titleLabel = UILabel()
        titleLabel.text = "Como jogar?"
        titleLabel.font = UIFont(name: "ClashDisplay-Semibold", size: 60)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0

        let descriptionLabel = UILabel()
        descriptionLabel.text = "(Sempre tem alguém que pergunta.)"
        descriptionLabel.font = UIFont(name: "GeneralSans-Italic", size: 34)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0
        
        let instructions = makeInstructionStack()

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            instructions
        ])
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -32)
        ])

        //TODO: DELETE
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
    
    private func makeInstructionStack() -> UIStackView {
        let first = makeInstructionsLabel(description: "O jogo tem três rodadas no total.", number: 1, isOnTop: true)
        let second = makeInstructionsLabel(description: "A cada rodada, uma letra é sorteada.", number: 2, isOnTop: false)
        let third = makeInstructionsLabel(description: "Cinco categorias aparecem — uma por vez.", number: 3, isOnTop: true)
        let fourth = makeInstructionsLabel(description: "Use a letra da rodada pra responder a categoria.", number: 4, isOnTop: false)
        let fifth = makeInstructionsLabel(description: "Analise e valide as respostas.", number: 5, isOnTop: true, isLast: true)
        
        let stack = UIStackView(arrangedSubviews: [
            first,
            second,
            third,
            fourth,
            fifth
        ])
        stack.axis = .horizontal
        stack.spacing = 30
        stack.alignment = .top
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }
    
    private func makeInstructionsLabel(description: String, number: Int, isOnTop: Bool, isLast: Bool = false) -> UIView {
        let offset = 80.0
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: 320),
            ])
        
        let numberLabel = UILabel()
        numberLabel.text = String(format: "%02d", number)
        numberLabel.font = UIFont(name: "GeneralSans-Regular", size: 48)
        numberLabel.textColor = .systemPink
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let text = UILabel()
        text.text = description
        text.font = UIFont(name: "ClashDisplay-Regular", size: 38)
        text.textColor = .white
        text.textAlignment = .center
        text.numberOfLines = 0
        text.translatesAutoresizingMaskIntoConstraints = false
    
        
        let lineImageName = isOnTop ? "lineTop" : "lineBottom"
        let lineImage = UIImageView(image: UIImage(named: lineImageName))
        lineImage.contentMode = .scaleAspectFill
        lineImage.translatesAutoresizingMaskIntoConstraints = false
        lineImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(numberLabel)
        view.addSubview(text)

        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: isOnTop ? 0 : offset),
            numberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            text.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 4),
            text.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            text.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4),
            text.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        if !isLast {
            view.addSubview(lineImage)

            if isOnTop {
                NSLayoutConstraint.activate([
                    lineImage.topAnchor.constraint(equalTo: numberLabel.centerYAnchor),
                    lineImage.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 40)
                ])
            } else {
                NSLayoutConstraint.activate([
                    lineImage.bottomAnchor.constraint(equalTo: numberLabel.centerYAnchor),
                    lineImage.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 40)
                ])
            }
        }
        
        return view
    }
}
