//
//  StarsBackgroundTVView.swift
//  stop_tv
//
//  Created by Raissa Parente on 01/07/25.
//
import UIKit

final class StarsBackgroundTVView: UIView {

    private var topStarTopConstraint: NSLayoutConstraint?
    private var topStarTrailingConstraint: NSLayoutConstraint?
    private var bottomStarBottomConstraint: NSLayoutConstraint?
    private var bottomStarLeadingConstraint: NSLayoutConstraint?

    let background: UIImageView = {
        let bg = UIImageView(image: UIImage(named: "paperTexture"))
        bg.contentMode = .scaleAspectFill
        bg.translatesAutoresizingMaskIntoConstraints = false
        return bg
    }()
    
    let topStar: UIImageView = {
        let star = UIImageView(image: UIImage(named: "Estrela1"))
        star.contentMode = .scaleAspectFit
        star.translatesAutoresizingMaskIntoConstraints = false
        return star
    }()
    
    let bottomStar: UIImageView = {
        let star = UIImageView(image: UIImage(named: "Estrela2"))
        star.contentMode = .scaleAspectFit
        star.translatesAutoresizingMaskIntoConstraints = false
        return star
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        insertSubview(background, at: 0)
        insertSubview(topStar, at: 1)
        insertSubview(bottomStar, at: 1)

        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),

            topStar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            topStar.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),

            bottomStar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
            bottomStar.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4),
        ])

        topStarTopConstraint = topStar.topAnchor.constraint(equalTo: topAnchor)
        topStarTrailingConstraint = topStar.trailingAnchor.constraint(equalTo: trailingAnchor)
        bottomStarBottomConstraint = bottomStar.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomStarLeadingConstraint = bottomStar.leadingAnchor.constraint(equalTo: leadingAnchor)

        NSLayoutConstraint.activate([
            topStarTopConstraint!,
            topStarTrailingConstraint!,
            bottomStarBottomConstraint!,
            bottomStarLeadingConstraint!,
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let offset = bounds.width * 0.15
        topStarTopConstraint?.constant = -offset
        topStarTrailingConstraint?.constant = offset

        bottomStarBottomConstraint?.constant = offset
        bottomStarLeadingConstraint?.constant = -offset
    }
}
