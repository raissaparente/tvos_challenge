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
    }
    
    let action: Action
    var playerName: String? = nil
    
    var status: ConnectionStatus? = nil
    var category: String? = nil
    var answer: String? = nil
    var isAnswerValid: Bool? = nil
    var currentIndex: Int?
    var categories: [String]? = nil

    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
