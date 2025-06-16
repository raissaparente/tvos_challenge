//
//  RoundTestViewModel.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//
import Foundation
import Combine

class RoundViewModel {
    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var currentIndex = 0
    @Published private(set) var answers: [String: String] = [:]
    var connectionManager: ConnectionManager
    var gameService: GameService!

    var categories: [String] {
        gameService.categories
    }

    var currentCategory: String {
        guard currentIndex < categories.count else { return "" }
        return categories[currentIndex]
    }

    var isFinished: Bool {
        currentIndex >= categories.count
    }

    init(connectionManager: ConnectionManager) {
        self.connectionManager = connectionManager
    }

    func saveAnswer(_ answer: String) {
        guard !isFinished else { return }
        let category = currentCategory
        answers[category] = answer
        currentIndex += 1
    }

    func sendAnswer() {
        let gameaction = GameAction(action: .sendAnswer, playerName: connectionManager.myPeerId.displayName, category: currentCategory, answer: answers[currentCategory], isAnswerValid: nil)

        connectionManager.send(gameAction: gameaction)
    }
}
