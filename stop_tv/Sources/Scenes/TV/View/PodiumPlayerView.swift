//
//  PodiumPlayerView.swift
//  stop_tv
//
//  Created by Raissa Parente on 01/07/25.
//

import UIKit
import StopPlay

class PodiumPlayerView: UIView {

    private let nameLabel = UILabel()
    private let pointsLabel = UILabel()
    private let image = UIImageView()

    init(player: Player?, place: Int) {
        super.init(frame: .zero)
        
        if place == 1 {
                transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        setupImage(for: place)
        setupView(player: player, place: place)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(player: Player?, place: Int) {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.textAlignment = .center
        pointsLabel.textAlignment = .center
        
        nameLabel.textColor = .white
        pointsLabel.textColor = .white
        
        nameLabel.font = UIFont(name: "ClashDisplay-Semibold", size: 40)
        pointsLabel.font = UIFont(name: "ClashDisplay-Regular", size: 30)
        
        if let player = player {
            nameLabel.text = player.name
            pointsLabel.text = "\(player.points) pontos"
        } else {
            nameLabel.text = "-"
            pointsLabel.text = "-"
            applyGrayscale(to: image)
        }

        let stack = UIStackView(arrangedSubviews: [image, nameLabel, pointsLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            image.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
            
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupImage(for place: Int) {
        
         var imageName: String {
             switch place {
             case 1:
                 return "01"
             case 2:
                 return "02"
             case 3:
                 return "03"
             default:
                 return "default"
             }
        }
        
        image.image = UIImage(named: imageName)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func applyGrayscale(to imageView: UIImageView) {
        guard let currentImage = imageView.image else { return }
        
        let ciImage = CIImage(image: currentImage)
        let grayscale = CIFilter(name: "CIColorControls")
        grayscale?.setValue(ciImage, forKey: kCIInputImageKey)
        grayscale?.setValue(0.0, forKey: kCIInputSaturationKey) // remove cor
        
        if let output = grayscale?.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(output, from: output.extent) {
                imageView.image = UIImage(cgImage: cgImage)
            }
        }
    }
}

