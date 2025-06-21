//
//  GameAction.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//

import Foundation

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
