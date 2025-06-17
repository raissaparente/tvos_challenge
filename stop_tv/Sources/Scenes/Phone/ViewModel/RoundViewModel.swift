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
    @Published private(set) var answers: [String: String] = [:] {
        didSet {
            print("🔧 setAnswers chamado com valor: \(answers) - VIEWMODEL")
        }
    }
    var connectionManager: ConnectionManager
    var gameService: GameService
    var categories: [String] = []
    var currentCategory: String {
        guard currentIndex < categories.count else { return "" }
        return categories[currentIndex]
    }

    var isFinished: Bool {
        currentIndex >= categories.count
    }

    init(connectionManager: ConnectionManager, gameService: GameService) {
        self.connectionManager = connectionManager
        self.gameService = gameService
    }
    
    func setCurrentIndex(_ index: Int) {
        print("🔧 setCurrentIndex chamado com valor: \(index)")
        currentIndex = index
    }

    func saveAnswer(_ answer: String) {
        guard !isFinished else { return }
        let category = currentCategory
        answers[category] = answer
        currentIndex += 1
    }

    func sendAnswer() {
        let gameAction = GameAction(
            action: .sendAnswer,
            playerName: connectionManager.myPeerId.displayName,
            category: currentCategory,
            answer: answers[currentCategory],
            isAnswerValid: nil,
            currentIndex: currentIndex
        )

        connectionManager.send(gameAction: gameAction)
    }

    func setCategories() {
        let categories = gameService.draw5Categories()

        self.categories = categories


        let gameAction = GameAction(
            action: .setCategories,
            categories: categories
        )

        connectionManager.send(gameAction: gameAction)
    }




}
