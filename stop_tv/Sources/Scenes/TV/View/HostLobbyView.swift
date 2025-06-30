//
//  HostLobbyView.swift
//  stop_tv
//
//  Created by Raissa Parente on 24/06/25.
//

import UIKit

final class HostLobbyView: UIView {
    
    let leftPanel = LobbyLeftPanelView()
    let rightPanel = LobbyRightPanelView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        leftPanel.translatesAutoresizingMaskIntoConstraints = false
        rightPanel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(leftPanel)
        addSubview(rightPanel)

        NSLayoutConstraint.activate([
            leftPanel.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftPanel.topAnchor.constraint(equalTo: topAnchor),
            leftPanel.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftPanel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),

            rightPanel.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightPanel.topAnchor.constraint(equalTo: topAnchor),
            rightPanel.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightPanel.leadingAnchor.constraint(equalTo: leftPanel.trailingAnchor)
        ])
    }
}


final class LobbyLeftPanelView: UIView {

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
        titleLabel.text = "Abra o app no seu celular e identifique-se."
        titleLabel.font = UIFont(name: "ClashDisplay-Semibold", size: 50)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0

        let descriptionLabel = UILabel()
        descriptionLabel.text = "Preferencialmente com um nome que não gere processos."
        descriptionLabel.font = UIFont(name: "GeneralSans-Italic", size: 34)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0

        let downloadLabel = UILabel()
        downloadLabel.text = "Não tem o app?"
        downloadLabel.font = UIFont(name: "ClashDisplay-Semibold", size: 55)
        downloadLabel.textColor = .white

        let qrcode = UIImageView(image: UIImage(named: "qrCode"))
        qrcode.contentMode = .scaleAspectFill
        qrcode.translatesAutoresizingMaskIntoConstraints = false
        qrcode.heightAnchor.constraint(equalToConstant: 400).isActive = true
        qrcode.widthAnchor.constraint(equalToConstant: 400).isActive = true

        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            UIView(),
            downloadLabel,
            qrcode
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -32)
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
}


final class LobbyRightPanelView: UIView {

    let nameList = UIStackView()
    let inviteButton = CapsuleButton.createForTV(withTitle: "Continuar", target: nil, action: #selector(dummy))

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
