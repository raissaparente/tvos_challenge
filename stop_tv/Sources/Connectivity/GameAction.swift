import Foundation
import StopPlay

enum GameActionType: String, Codable {
    case sendAnswer
    case voteAnswer
    case changeStatus
    case changeCategory
    case setCategories
    case setAnswers
}

struct GameAction<Payload: Codable>: Codable {
    let type: GameActionType
    let payload: Payload

    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}

//payloads
struct EmptyPayload: Codable {}

struct SendAnswerPayload: Codable {
    let playerName: Player
    let answer: Response
}

struct ChangeStatusPayload: Codable {
    let status: ConnectionStatus
}

struct SetCategoriesPayload: Codable {
    let categories: [String]
}

struct VotePayload: Codable {
    let category: String
    let voterName: String
    let selectedIndexes: Set<Int>
}

struct SetAnswersPayload: Codable {
    let answers: [String: [Response]]
}

//struct pra desembrulhar e saber o tipo de payload
struct GameActionTypeWrapper: Codable {
    let type: GameActionType
}
