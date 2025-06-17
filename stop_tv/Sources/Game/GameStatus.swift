//
//  GameStatus.swift
//  stop_tv
//
//  Created by Júlia Saboya on 16/06/25.
//

enum GameStatus: String, Codable, CaseIterable {
    case connecting
    case startMatch
    case startRound
    case waitingForAnswers
    case votingAnswers
    case endRound
    case showingRanking
    case endMatch
}

let allStatuses = GameStatus.allCases.map { $0.rawValue }
