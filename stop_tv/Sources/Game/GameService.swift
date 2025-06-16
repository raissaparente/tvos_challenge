//
//  GameService.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//
import Foundation

class GameService: ObservableObject {
    var currentLetter = "a"
    var currentCategory: String = "Nome"
    @Published var dump: [String] = ["teste"]
    
    @Published var status: GameStatus = .awaiting

    
    func updateAnswers(for category: String, with answer: String) {
        dump.append(answer)
        print(dump)
    }
}
