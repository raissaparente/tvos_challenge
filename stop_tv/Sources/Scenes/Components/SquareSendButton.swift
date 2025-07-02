//
//  SquareSendButton.swift
//  stop_tv
//
//  Created by Raissa Parente on 29/06/25.
//

import UIKit

class SquareSendButton: UIButton {

    private let normalColor = UIColor.customYellow

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        backgroundColor = normalColor
        let image = UIImage(systemName: "paperplane.fill")
        setImage(image, for: .normal)
        tintColor = .black
        
        layer.cornerRadius = 8
    }
}
