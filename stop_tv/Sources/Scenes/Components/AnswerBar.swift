//
//  AnswerBar.swift
//  stop_tv
//
//  Created by Gabriel Oliveira Plutarco on 30/06/25.
//
// aqui é so repetir 8 vezes isso e organizar a tela, a questao é:
// de onde vem as respostas?
// onde fica essa tela?
import UIKit
class FatiaView: UIView {
    
    private let fatiaView = UIView()
    private let numeroLabel = UILabel()
    private let divisoriaView = UIView()
    private let textoView = UIView()
    private let textoLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    func configure(numero: Int, texto: String) {
        numeroLabel.text = "\(numero)"
        textoLabel.text = texto
    }

    private func setupUI() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.customBege

        fatiaView.translatesAutoresizingMaskIntoConstraints = false
        fatiaView.backgroundColor = UIColor.customPink
        addSubview(fatiaView)

        numeroLabel.translatesAutoresizingMaskIntoConstraints = false
        numeroLabel.textColor = .white
        numeroLabel.font = .boldSystemFont(ofSize: 24)
        numeroLabel.textAlignment = .center
        fatiaView.addSubview(numeroLabel)

        divisoriaView.translatesAutoresizingMaskIntoConstraints = false
        divisoriaView.backgroundColor = .darkGray
        addSubview(divisoriaView)

        textoView.translatesAutoresizingMaskIntoConstraints = false
        textoView.backgroundColor = UIColor.black
        addSubview(textoView)

        textoLabel.translatesAutoresizingMaskIntoConstraints = false
        textoLabel.numberOfLines = 0
        textoLabel.font = .systemFont(ofSize: 18, weight: .medium)
        textoView.addSubview(textoLabel)

        NSLayoutConstraint.activate([
            fatiaView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fatiaView.topAnchor.constraint(equalTo: topAnchor),
            fatiaView.bottomAnchor.constraint(equalTo: bottomAnchor),
            fatiaView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),

            numeroLabel.centerXAnchor.constraint(equalTo: fatiaView.centerXAnchor),
            numeroLabel.centerYAnchor.constraint(equalTo: fatiaView.centerYAnchor),

            divisoriaView.leadingAnchor.constraint(equalTo: fatiaView.trailingAnchor),
            divisoriaView.topAnchor.constraint(equalTo: topAnchor),
            divisoriaView.bottomAnchor.constraint(equalTo: bottomAnchor),
            divisoriaView.widthAnchor.constraint(equalToConstant: 1),

            textoView.leadingAnchor.constraint(equalTo: divisoriaView.trailingAnchor),
            textoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textoView.topAnchor.constraint(equalTo: topAnchor),
            textoView.bottomAnchor.constraint(equalTo: bottomAnchor),

            textoLabel.leadingAnchor.constraint(equalTo: textoView.leadingAnchor, constant: 8),
            textoLabel.trailingAnchor.constraint(equalTo: textoView.trailingAnchor, constant: -8),
            textoLabel.centerYAnchor.constraint(equalTo: textoView.centerYAnchor),
        ])
    }
}

#Preview {
    FatiaView()
}
