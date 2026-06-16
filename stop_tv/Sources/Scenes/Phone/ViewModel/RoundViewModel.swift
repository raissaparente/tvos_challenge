//
//  RoundTestViewModel.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//
import Foundation
import StopPlay


class RoundViewModel {
    @Published private(set) var currentIndex = 0 // TODO: mudar para categoryIndex
    @Published var answers: [String: [Response]] = [:]
    @Published var answerIndex: Int?
    @Published var playersWhoAnswered: [String] = []
    @Published var currentLetter: String?
    
    var connectionManager: ConnectionManager
    var gameService: GameService
    weak var votingViewModel: VotingViewModel?
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
        prepareNewRound(with: newCategories)

        let payload = SetCategoriesPayload(categories: newCategories)
        let action = GameAction(type: .setCategories, payload: payload)
        connectionManager.send(gameAction: action)
    }

    func advanceCategory() {
        currentIndex += 1
    }

    func prepareNewRound(with categories: [String]) {
        currentIndex = 0
        answers = [:]
        playersWhoAnswered.removeAll()
        didAllPlayersAnswer = false
        didAllPlayersVote = false
        self.categories = categories
        votingViewModel?.resetVotes()
    }

    func saveAnswer(_ answer: Response, from playerName: String? = nil) {
        guard !isFinished else { return }
        let category = currentCategory

        if let playerName {
            guard !playersWhoAnswered.contains(playerName) else { return }
            playersWhoAnswered.append(playerName)
        }

        var currentAnswers = answers[category] ?? []
        currentAnswers.append(answer)
        answers[category] = currentAnswers
    }

    func setAnswers() {
        let payload = SetAnswersPayload(answers: self.answers)
        let action = GameAction(type: .setAnswers, payload: payload)
        connectionManager.send(gameAction: action)
    }

    func sendAnswer(_ answer: Response) {
        let player = Player(name: connectionManager.myPeerId.displayName)

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

        currentIndex = nextIndex
        resetCategory()
        changeStatus(to: .category)
    }
    
    func startVoting() {
        didAllPlayersAnswer = false
        setAnswers()
        changeStatus(to: .startVote)
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
    
    func resetCategory() {
        playersWhoAnswered.removeAll()
        didAllPlayersAnswer = false
    }
    
    func reset() {
        currentIndex = 0
        answers = [:]
        categories = []
        playersWhoAnswered.removeAll()
        currentLetter = nil
        didAllPlayersAnswer = false
        didAllPlayersVote = false
        votingViewModel?.resetVotes()
    }
    

}

extension RoundViewModel {
    func calculateScore(for answer: Response, in category: String) -> Int {
        guard let currentLetter, answer.isAnswerValid(letter: currentLetter) else {
            print("Resposta inválida pela letra.")
            return 0
        }

        guard let votes = votingViewModel?.votesByCategory[category]?[answer.id] else {
            print("⚠️ Votos não encontrados para a resposta \(answer.text)")
            return 0
        }

        let votesAgainst = votes.filter { !$0 }.count // true
        let votesFor = votes.filter { $0 }.count // false

        guard votesFor >= votesAgainst else {
            print("votos falsos ganharam")
            return 0
        }

        var score = 100
        if answer.isRepeated {
            score -= 50
        }

        return score
    }
}


