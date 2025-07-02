//
//  StarsBackgroundView.swift
//  stop_tv
//
//  Created by Raissa Parente on 29/06/25.
//
import UIKit


final class StarsBackgroundView: UIView {
    
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
    
    func setupView() {
        insertSubview(background, at: 0)
        insertSubview(topStar, at: 1)
        insertSubview(bottomStar, at: 1)
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: topAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            background.leadingAnchor.constraint(equalTo: leadingAnchor),
            background.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            topStar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            bottomStar.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),

            topStar.topAnchor.constraint(equalTo: topAnchor, constant: -topStar.frame.height*0.4),
            topStar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: topStar.frame.height*0.5),
            
            bottomStar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomStar.frame.height*0.4),
            bottomStar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -bottomStar.frame.height*0.5),
        ])
    }
}
