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
    @Published private(set) var answers: [String: CurrentValueSubject<[String], Never>] = [:]
    
    var connectionManager: ConnectionManager
    var gameService: GameService
    var categories: [String] = []
    var currentCategory: String {
        guard currentIndex < categories.count else { return "raissa" }
        return categories[currentIndex]
    }

     var isFinished: Bool {
             currentIndex >= categories.count
    }
    
    @Published var didAllPlayersAnswer: Bool {
        
        didSet {
            if let answers = answers[currentCategory] {
                var currentAnswers = answers.value
                
                didAllPlayersAnswer = currentAnswers.count == connectionManager.connectedPeers.count
                
            } else { didAllPlayersAnswer = false }
        }
    }

    init(connectionManager: ConnectionManager, gameService: GameService) {
        self.connectionManager = connectionManager
        self.gameService = gameService
        
        self.didAllPlayersAnswer = false
    }
    
    func setCurrentIndex(_ index: Int) {
        print("🔧 setCurrentIndex chamado com valor: \(index)")
        currentIndex = index
    }


    func saveAnswer(_ answer: String) {
        guard !isFinished else { return }
        
            let category = currentCategory

            if let subject = answers[category] {
                var currentAnswers = subject.value
                currentAnswers.append(answer)
                subject.send(currentAnswers)
            } else {
                answers[category] = CurrentValueSubject<[String], Never>([answer])
            }
    }

    func sendAnswer(_ answer: String) {
        let gameAction = GameAction(
            action: .sendAnswer,
            playerName: connectionManager.myPeerId.displayName,
            category: currentCategory,
            answer: answer,
            isAnswerValid: nil,
            currentIndex: currentIndex,
            nextIndex:  currentIndex + 1
        )

        connectionManager.send(gameAction: gameAction)
//        currentIndex += 1

    }
    
    func changeCategory() {
        currentIndex += 1

        let gameAction = GameAction(action: .changeCategory, nextIndex: currentIndex + 1)
        
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
