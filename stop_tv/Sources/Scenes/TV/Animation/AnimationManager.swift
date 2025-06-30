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
    func animateRodada(
        label: UILabel,
        in view: UIView,
        originalText: String,
        startConstraints: (x: NSLayoutConstraint, y: NSLayoutConstraint),
        endConstraints: (x: NSLayoutConstraint, y: NSLayoutConstraint),
        completion: (() -> Void)? = nil
    ) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = originalText
        label.alpha = 0
        view.addSubview(label)

        NSLayoutConstraint.activate([startConstraints.x, startConstraints.y])
        view.layoutIfNeeded() 

        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
            label.alpha = 1
            view.layoutIfNeeded()
        }) { _ in
            var shuffleCount = 0
            let maxShuffles = 10
            let shuffleInterval = 0.05

            Timer.scheduledTimer(withTimeInterval: shuffleInterval, repeats: true) { timer in
                shuffleCount += 1
                label.text = String(originalText.shuffled())

                if shuffleCount >= maxShuffles {
                    timer.invalidate()
                    label.text = originalText

                    NSLayoutConstraint.deactivate([startConstraints.x, startConstraints.y])
                    NSLayoutConstraint.activate([endConstraints.x, endConstraints.y])

                    UIView.animate(withDuration: 0.8,
                                   delay: 0,
                                   usingSpringWithDamping: 0.7,
                                   initialSpringVelocity: 0.8,
                                   options: [.curveEaseInOut],
                                   animations: {
                        label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                        label.alpha = 0.9
                        view.layoutIfNeeded()
                    }, completion: { _ in
                        completion?()
                    })
                }
            }
        }
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
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
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
