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
    @Published private(set) var answers: [String: [String]] = [:]
    
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
    
    @Published var didAllPlayersAnswer: Bool = false
    @Published var didAllPlayersVote: Bool = false
        

    init(connectionManager: ConnectionManager, gameService: GameService) {
        self.connectionManager = connectionManager
        self.gameService = gameService
        
//        self.didAllPlayersAnswer = false
    }
    
    func setCurrentIndex(_ index: Int) {
        print("🔧 setCurrentIndex chamado com valor: \(index)")
        currentIndex = index
    }


    func saveAnswer(_ answer: String) {
        guard !isFinished else { return }
        let category = currentCategory
        
        var currentAnswers = answers[category] ?? []
        currentAnswers.append(answer)
        answers[category] = currentAnswers
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
        let gameAction = GameAction(action: .changeCategory, nextIndex: currentIndex + 1)
        
        connectionManager.send(gameAction: gameAction)
        
        currentIndex += 1
        
        print("mandou msg de mudar categoria")
    }
    
    func startVoting() {
        let gameAction = GameAction(action: .startVote)
        
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
