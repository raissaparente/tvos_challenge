//
//  MatchManager.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//

import Foundation

class MatchManager: ObservableObject {
    @Published var maxRoundsCount: Int = 3
    @Published var isRoundFinished: Bool = false
}
