//
//  RankingPlayerCardView.swift
//  stop_tv
//
//  Created by Raissa Parente on 01/07/25.
//

import UIKit

class RankingPlayerCardView: UIView {

    private let rankContainer = UIView()
    private let rankLabel = UILabel()
    private let nameLabel = UILabel()
    private let pointsContainer = UIView()
    private let pointsLabel = UILabel()

    private var cardHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func configure(rank: Int, name: String, points: Int, isTop: Bool) {
        let formattedRank = rank < 10 ? "0\(rank)" : "\(rank)"
        rankLabel.text = formattedRank
        nameLabel.text = name
        pointsLabel.text = "\(points) pontos"

        rankLabel.font = UIFont(name: "ClashDisplay-Semibold", size: 45) ?? .boldSystemFont(ofSize: 45)
        nameLabel.font = UIFont(name: "ClashDisplay-Medium", size: 36) ?? .systemFont(ofSize: 36)
        pointsLabel.font = UIFont(name: "ClashDisplay-Semibold", size: 38) ?? .boldSystemFont(ofSize: 38)

        cardHeightConstraint?.isActive = false
        cardHeightConstraint = heightAnchor.constraint(equalToConstant: 100)
        cardHeightConstraint?.isActive = true

        if isTop {
            backgroundColor = UIColor.customYellow
            rankContainer.backgroundColor = UIColor.customYellow
            pointsContainer.backgroundColor = UIColor.customYellow
        } else {
            backgroundColor = UIColor.customBege
            rankContainer.backgroundColor = UIColor.customBege
            pointsContainer.backgroundColor = UIColor.customBege
        }
    }

    private func setupUI() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = UIColor.customBege
        translatesAutoresizingMaskIntoConstraints = false

        rankContainer.translatesAutoresizingMaskIntoConstraints = false
        rankContainer.backgroundColor = UIColor.customYellow
        addSubview(rankContainer)

        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        rankLabel.textColor = .black
        rankLabel.textAlignment = .center
        rankContainer.addSubview(rankLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.8
        addSubview(nameLabel)

        pointsContainer.translatesAutoresizingMaskIntoConstraints = false
        pointsContainer.backgroundColor = UIColor.customYellow
        addSubview(pointsContainer)

        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.textColor = .black
        pointsLabel.textAlignment = .center
        pointsContainer.addSubview(pointsLabel)

        NSLayoutConstraint.activate([
            rankContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            rankContainer.topAnchor.constraint(equalTo: topAnchor),
            rankContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            rankContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.12),

            rankLabel.centerXAnchor.constraint(equalTo: rankContainer.centerXAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: rankContainer.centerYAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: rankContainer.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: pointsContainer.leadingAnchor, constant: -8),

            pointsContainer.topAnchor.constraint(equalTo: topAnchor),
            pointsContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            pointsContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            pointsContainer.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22),

            pointsLabel.centerXAnchor.constraint(equalTo: pointsContainer.centerXAnchor),
            pointsLabel.centerYAnchor.constraint(equalTo: pointsContainer.centerYAnchor),
        ])
    }
}
