//
//  RoundTestViewModel.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//
import Foundation
import Combine
import StopPlay

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
    }
    
    func setCurrentIndex(_ index: Int) {
        print("🔧 setCurrentIndex chamado com valor: \(index)")
        currentIndex = index
    }

    func advanceCategory() {
        currentIndex += 1
    }

    func saveAnswer(_ answer: String) {
        guard !isFinished else { return }
        let category = currentCategory
        
        var currentAnswers = answers[category] ?? []
        currentAnswers.append(answer)
        answers[category] = currentAnswers
    }

    func sendAnswer(_ answer: String) {
        let payload = SendAnswerPayload(
            playerName: connectionManager.myPeerId.displayName,
            answer: answer
        )
        
        let action = GameAction(type: .sendAnswer, payload: payload)
        connectionManager.send(gameAction: action)
    }
    
    func changeCategory() {
        let nextIndex = currentIndex + 1
        let action = GameAction(type: .changeCategory, payload: EmptyPayload())
        connectionManager.send(gameAction: action)

        // local
        currentIndex = nextIndex
        self.gameService.status = .category
    }
    
    func endVoting(){
        //é chamada na TV
        let payload = ChangeStatusPayload(status: .endVote)
        let action = GameAction(type: .changeStatus, payload: payload)
        connectionManager.send(gameAction: action)
        
        //local
        self.gameService.status = .endVote
    }
    
    func startVoting() {
        //é chamada na TV
        //mudar nome pra +reset
        didAllPlayersAnswer = false
        
        let payload = ChangeStatusPayload(status: .startVote)
            let action = GameAction(type: .changeStatus, payload: payload)
            connectionManager.send(gameAction: action)
    }

    func setCategories() {
        let categories = gameService.draw5Categories()
        self.categories = categories

        let payload = SetCategoriesPayload(categories: categories)
            let action = GameAction(type: .setCategories, payload: payload)
            connectionManager.send(gameAction: action)
    }
    
    func changeStatus(to newStatus: ConnectionStatus) {
        // Atualiza status local
        gameService.status = newStatus

        // Cria e envia a ação
        let payload = ChangeStatusPayload(status: newStatus)
        let action = GameAction(type: .changeStatus, payload: payload)
        connectionManager.send(gameAction: action)

        print("🔁 Status alterado e enviado: \(newStatus)")
    }
    
    var isLastCategory: Bool {
        return currentIndex + 1 >= categories.count
    }
    
    func reset() {
        currentIndex = 0
        answers = [:]
        categories = []
        didAllPlayersAnswer = false
        didAllPlayersVote = false
    }
    
    func printAnswers() {
        print("\n📝 Respostas por categoria:")
        for (categoria, respostas) in answers {
            print("📚 Categoria: \(categoria)")
            for (index, resposta) in respostas.enumerated() {
                print("   🔹 Resposta \(index + 1): \(resposta)")
            }
        }
        print("🔚 Fim das respostas\n")
    }
}
