//
//  ConnectedPlayersView.swift
//  stop_tv
//
//  Created by Raissa Parente on 25/06/25.
//
import UIKit

final class ConnectedPlayersView: UIView {

    let nameList = UIStackView()
    let inviteButton = CapsuleButton.create(withTitle: "Continuar", target: nil, action: #selector(dummy))

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        let titleLabel = UILabel()
        titleLabel.text = "Prontos...\npelo menos no nome"
        titleLabel.font = UIFont(name: "Chalkduster", size: 52)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0

        nameList.axis = .vertical
        nameList.spacing = 12
        nameList.alignment = .fill

        let buttonWrapper = UIView()
        buttonWrapper.translatesAutoresizingMaskIntoConstraints = false
        buttonWrapper.addSubview(inviteButton)
        inviteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inviteButton.topAnchor.constraint(equalTo: buttonWrapper.topAnchor),
            inviteButton.bottomAnchor.constraint(equalTo: buttonWrapper.bottomAnchor),
            inviteButton.centerXAnchor.constraint(equalTo: buttonWrapper.centerXAnchor)
        ])

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            nameList,
            UIView(),
            buttonWrapper
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ])

        let bg = UIImageView(image: UIImage(named: "notebookPaper"))
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

    @objc private func dummy() {}
}
