//
//  UIView+Background.swift
//  stop_tv
//
//  Created by Raissa Parente on 29/06/25.
//
import UIKit

extension UIView {
    func addBackgroundView(_ backgroundView: UIView) {
        backgroundColor = .black
        
        insertSubview(backgroundView, at: 0)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
