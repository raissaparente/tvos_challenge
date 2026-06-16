//
//  ConnectionStatus.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//

enum ConnectionStatus: Codable {
    case awaiting, connecting, startGame, category, startVote, endVote, partialRanking, finalRanking
}
