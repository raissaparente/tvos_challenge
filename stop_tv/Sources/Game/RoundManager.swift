//
//  RoundManager.swift
//  stop_tv
//
//  Created by Júlia Saboya on 13/06/25.
//

import Foundation

enum RoundState {
    case started
    case inProgress
    case drawingLetter // sorteando letra
    case watingForAnswer // esperando entrada de cada categoria
    case allAnswersReceived // todas as pessoas responderam uma categoria
    case waitingForVotation // mostrando as respostas de uma categoria e aguardando votacao
    case finished // todas as categorias daquela letra finalizadas e votadas
}

class RoundManager: ObservableObject {
    @Published var count: Int = 1
    @Published var roundState: RoundState?
    let categories: [String] = ["nome", "profissao","lugar", "MSE","fruta", "CEP","comida", "filme","animal", "marca","celebridade", "banda","música", "cor","jogo", "objeto","personagem", "hobby","PCH", "time esportivo"]

    func draw5Categories() -> [String] {
        let shuffledCategories = categories.shuffled()
        print(Array(shuffledCategories[0..<5]))
        return Array(shuffledCategories[0..<5])
    }
}
