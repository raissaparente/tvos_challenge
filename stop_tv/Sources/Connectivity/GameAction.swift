//
//  GameAction.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//

import Foundation

struct GameAction: Codable {
    enum Action: Int, Codable {
        case sendAnswer
        case voteAnswer
        case changeStatus
        case setCategories
        case changeCategory
        case startVote
        case endVote
    }
    
    let action: Action
    var playerName: String? = nil
    
    var status: ConnectionStatus? = nil
    var category: String? = nil
    var answer: String? = nil
    var isAnswerValid: Bool? = nil
    var currentIndex: Int?
    var nextIndex: Int?
    var categories: [String]? = nil
import Foundation

enum GameActionType: String, Codable {
    case sendAnswer
    case voteAnswer
    case changeStatus
}

struct GameAction<Payload: Codable>: Codable {
    let type: GameActionType
    let payload: Payload

    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}

//payloads
struct SendAnswerPayload: Codable {
    let playerName: String
    let answer: String
}


struct ChangeStatusPayload: Codable {
    let status: ConnectionStatus
}
