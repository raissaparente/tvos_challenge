//
//  MatchManager.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//

import Foundation

class MatchManager: ObservableObject {
    var round: RoundManager?
    @Published var maxRoundsCount: Int = 3
    @Published var currentRound: Int? {
        didSet {
            currentRound = round?.count
        }
    }
    @Published var isRoundFinished: Bool = false
}
