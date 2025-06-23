//
//  GameAction.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//

import Foundation


enum GameActionType: String, Codable {
    case sendAnswer
    case voteAnswer
    case changeStatus
    case changeCategory
    case setCategories
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
    let playerName: String
    let answer: String
}


struct ChangeStatusPayload: Codable {
    let status: ConnectionStatus
}

struct SetCategoriesPayload: Codable {
    let categories: [String]
}

//struct pra desembrulhar e saber o tipo de payload
struct GameActionTypeWrapper: Codable {
    let type: GameActionType
}
