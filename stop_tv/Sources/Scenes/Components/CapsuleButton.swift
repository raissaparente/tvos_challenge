//
//  CapsuleButton.swift
//  stop_tv
//
//  Created by Raissa Parente on 24/06/25.
//

import UIKit

class CapsuleButton: UIButton {

    var normalColor = UIColor.customYellow
    var highlightedColor = UIColor.systemPink
    var borderColor = UIColor.black
    private let shadowColor = UIColor.black

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
        setTitleColor(.black, for: .normal)
        layer.borderWidth = 2
        layer.borderColor = borderColor.cgColor
        
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)

    }
    override func layoutSubviews() {
            super.layoutSubviews()
            layer.cornerRadius = bounds.height / 8
        }
    
    override var isHighlighted: Bool {
            didSet {
                backgroundColor = isHighlighted ? highlightedColor : normalColor
            }
    }

    //função auxiliar para criar o botão com texto
    static func createForTV(withTitle title: String) -> CapsuleButton {
            let button = CapsuleButton(type: .system)
            button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "ClashDisplay-Semibold", size: 28)
    
        return button
        }
    
    static func createForPhone(withTitle title: String) -> CapsuleButton {
        let button = CapsuleButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "ClashDisplay-Semibold", size: 20)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        
        return button
    }
}
