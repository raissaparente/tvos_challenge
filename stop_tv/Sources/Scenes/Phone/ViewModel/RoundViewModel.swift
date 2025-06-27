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
    @Published private(set) var currentIndex = 0 // TODO: mudar para categoryIndex
    @Published var answers: [String: [Response]] = [:]
    @Published var answerIndex: Int?

    var connectionManager: ConnectionManager
    var gameService: GameService
    var categories: [String] = []
    var currentCategory: String {
        guard currentIndex < categories.count else { return "Categoria indefinida" }
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

    func setCategories() {
            let newCategories = gameService.draw5Categories()
            print("🟢 categorias sorteadas: \(newCategories)")
            self.categories = newCategories

        let payload = SetCategoriesPayload(categories: newCategories)
        let action = GameAction(type: .setCategories, payload: payload)
        connectionManager.send(gameAction: action)
    }

    func advanceCategory() {
        currentIndex += 1
    }

    func saveAnswer(_ answer: Response) {
        guard !isFinished else { return }
        let category = currentCategory

        var currentAnswers = answers[category] ?? []
        currentAnswers.append(answer)
        answers[category] = currentAnswers
    }

    func sendAnswer(_ answer: Response) {
        //FIXME: PLACEHOLDER DE PLAYER
        let player = Player(name: "Player 1")


        let payload = SendAnswerPayload(
            playerName: player,
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
    
    func startVoting() {
        didAllPlayersAnswer = false
        let payload = ChangeStatusPayload(status: .startVote)
        let action = GameAction(type: .changeStatus, payload: payload)
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

    func createAnswer(text: String) -> Response {
        let answer = Response(text: text)
        return answer
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

}


