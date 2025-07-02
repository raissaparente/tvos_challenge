//
//  AnimationManager.swift
//  stop_tv
//
//  Created by Gabriel Oliveira Plutarco on 18/06/25.
//
//uso:
/*
var animator: LetterAnimator!
E no viewDidLoad, depois de criar o label e o círculo:

animator = LetterAnimator(label: letterLabel, circleView: circle)
E no botão:

@objc func startDrawAnimation() {
    drawButton.isEnabled = false

    let finalLetter = letters.randomElement()!
    animator.animate(letter: String(finalLetter)) {
        self.drawButton.isEnabled = true
        print("Letra sorteada: \(finalLetter)")
    }
}
 */
import UIKit

class AnimationManager {
    private let label: UILabel
    private var imageTimer: Timer?
    private var currentImageIndex = 0
    private var timer: Timer?
    private let imageViewPaper: UIImageView?
    private let imageViewLetter: UIImageView?
    init(label: UILabel, imageViewLetter: UIImageView? = nil, imageViewPaper: UIImageView? = nil) {
        self.label = label
        self.imageViewLetter = imageViewLetter
        self.imageViewPaper = imageViewPaper
    }
    
    func animateRodadaSlotStyle(word: String, in container: UIView, completion: (() -> Void)? = nil) {
           let stackView = UIStackView()
           stackView.axis = .horizontal
           stackView.spacing = 2
           stackView.alignment = .center
           stackView.distribution = .equalSpacing
           stackView.translatesAutoresizingMaskIntoConstraints = false
           container.addSubview(stackView)

           NSLayoutConstraint.activate([
               stackView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
               stackView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
           ])

           var letterContainers: [UIView] = []

           for _ in word {
               let container = UIView()
               container.clipsToBounds = true
               container.translatesAutoresizingMaskIntoConstraints = false
               container.widthAnchor.constraint(equalToConstant: 80).isActive = true
               container.heightAnchor.constraint(equalToConstant: 100).isActive = true

               let label = UILabel()
               label.text = ""
               label.textAlignment = .center
               label.font = UIFont(name: "ClashDisplay-Bold", size: 80) ?? UIFont.systemFont(ofSize: 80, weight: .bold)
               label.textColor = .white
               label.frame = CGRect(x: 0, y: 0, width: 80, height: 100)

               container.addSubview(label)
               stackView.addArrangedSubview(container)
               letterContainers.append(container)
           }

        let totalLetters = word.count
        var completedCount = 0

        for (i, char) in word.enumerated() {
            let direction: CGFloat = i % 2 == 0 ? -1 : 1

            self.animateFixedLetterSlot(in: letterContainers[i], letter: char, direction: direction, iterations: 6) {
                completedCount += 1
                if completedCount == totalLetters {
                           DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                               stackView.isHidden = true
                               completion?()
                           }
                       }
                   }
               }
       }

       private func animateFixedLetterSlot(
           in container: UIView,
           letter: Character,
           direction: CGFloat,
           iterations: Int,
           completion: @escaping () -> Void
       ) {
           guard iterations > 0 else {
               if let label = container.subviews.first as? UILabel {
                   label.text = String(letter)
                   label.frame.origin.y = 0
               }
               completion()
               return
           }

           let height: CGFloat = 100
           let currentLabel = container.subviews.first as? UILabel
           currentLabel?.frame.origin.y = 0

           let nextLabel = UILabel()
           nextLabel.text = String(letter)
           nextLabel.textAlignment = .center
           nextLabel.font = currentLabel?.font
           nextLabel.textColor = currentLabel?.textColor
           nextLabel.frame = CGRect(x: 0, y: direction * height, width: 80, height: height)

           container.addSubview(nextLabel)

           UIView.animate(withDuration: 0.35, delay: 0, options: [.curveEaseInOut], animations: {
               currentLabel?.frame.origin.y -= direction * height
               nextLabel.frame.origin.y -= direction * height
           }, completion: { _ in
               currentLabel?.removeFromSuperview()
               self.animateFixedLetterSlot(in: container, letter: letter, direction: direction, iterations: iterations - 1, completion: completion)
           })
       }
    
    func animate(
        letter: String,
        duration: TimeInterval = 2.5,
        interval: TimeInterval = 0.05,
        completion: (() -> Void)? = nil
    ) {
        guard let imageViewLetter = imageViewLetter else {
            print("No imageView provided.")
            return
        }
        imageViewLetter.isHidden = false
        label.isHidden = true

        var elapsedTime: TimeInterval = 0
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            elapsedTime += interval

            let randomChar = (65...90).compactMap { UnicodeScalar($0) }.map { Character($0) }.randomElement()!
            let imageName = String(randomChar)

            // mudando entre as imagens
            UIView.transition(with: imageViewLetter, duration: 0.1, options: .transitionCrossDissolve, animations: {
                imageViewLetter.image = UIImage(named: imageName)
            }, completion: nil)

            if elapsedTime >= duration {
                timer.invalidate()
                // mostra a correya no fim
                UIView.transition(with: imageViewLetter, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    imageViewLetter.image = UIImage(named: letter.uppercased())
                }) { _ in
                    self.finishAnimation()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        completion?()
                    }
                }
            }
        }
    }
    func startPaperAnimation(images: [UIImage], interval: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
        guard let imageViewPaper = imageViewPaper else {
            return
        }

        imageViewPaper.isHidden = false
        imageViewPaper.layer.zPosition = 1
        imageTimer?.invalidate()
        currentImageIndex = 0

        let firstImage = images[0]
        imageViewPaper.image = firstImage.resize(to: CGSize(width: 400, height: 400))

        if images.count == 1 {
            Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
                completion?()
            }
            return
        }

        imageTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            guard let self = self, let imageViewPaper = self.imageViewPaper else {
                timer.invalidate()
                return
            }

            self.currentImageIndex += 1

            if self.currentImageIndex < images.count {
                let img = images[self.currentImageIndex]
                let resized = img.resize(to: CGSize(width: 500, height: 700))

                UIView.transition(with: imageViewPaper,
                                  duration: 0.15,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                      imageViewPaper.image = resized
                                  },
                                  completion: nil)

                if self.currentImageIndex == images.count - 1 {
                    timer.invalidate()
                    Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                        completion?()
                    }
                }
            } else {
                timer.invalidate()
            }
        }
    }

    private func finishAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.label.transform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        }) { _ in
            UIView.animate(withDuration: 0.4,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0.8,
                           options: [],
                           animations: {
                self.label.transform = .identity
            }, completion: nil)
        }
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
