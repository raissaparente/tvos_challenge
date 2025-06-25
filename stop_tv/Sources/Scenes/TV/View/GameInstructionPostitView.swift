//
//  GameInstructionPostitView.swift
//  stop_tv
//
//  Created by Raissa Parente on 25/06/25.
//
import UIKit

final class GameInstructionPostitView: UIView {
    
    let topPanel = InstructionsView()
    let bottomPanel = ConnectedPlayersView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        topPanel.translatesAutoresizingMaskIntoConstraints = false
        bottomPanel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(topPanel)
        addSubview(bottomPanel)

        NSLayoutConstraint.activate([
            topPanel.leadingAnchor.constraint(equalTo: leadingAnchor),
            topPanel.trailingAnchor.constraint(equalTo: trailingAnchor),
            topPanel.topAnchor.constraint(equalTo: topAnchor),
            topPanel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),

            bottomPanel.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomPanel.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomPanel.topAnchor.constraint(equalTo: topPanel.bottomAnchor),
            bottomPanel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        
        //Background
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
