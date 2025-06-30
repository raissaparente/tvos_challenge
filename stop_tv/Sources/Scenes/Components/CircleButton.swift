//
//  CircleButton.swift
//  stop_tv
//
//  Created by Raissa Parente on 30/06/25.
//


import UIKit

class CircleButton: UIButton {
    
    var normalColor = UIColor.customPink
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
        
        contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    
    //função auxiliar para criar o botão com texto
    static func create(withTitle title: String) -> CircleButton {
        let button = CircleButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont(name: "ClashDisplay-Semibold", size: 28)
        
        return button
    }
}
