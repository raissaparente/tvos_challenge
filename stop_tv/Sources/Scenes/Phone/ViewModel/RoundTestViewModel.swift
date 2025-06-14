//
//  RoundTestViewModel.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//

import Foundation

class RoundTestViewModel {
    private let roundManager: RoundManager
    private(set) var categories: [String] = []
    private(set) var answers: [String: String] = [:]
    private(set) var currentIndex = 0
    var currentCategory: String? {
        guard currentIndex < categories.count else { return nil }
        return categories[currentIndex]
    }

    init(manager: RoundManager) {
            self.roundManager = manager
            self.categories = manager.draw5Categories()
        }

    func saveAnswer(_ answer: String) {
        if let current = currentCategory {
            answers[current] = answer
            currentIndex += 1
        }
    }

    var isFinished: Bool {
        return currentIndex >= categories.count
    }
}
