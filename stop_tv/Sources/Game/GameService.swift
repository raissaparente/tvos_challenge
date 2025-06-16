//
//  GameService.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//
import Foundation
import StopPlay

class GameService: ObservableObject {
    var currentLetter = "a"
    var currentCategory: String = "Nome"
    @Published var dump: [String] = ["teste"]
    
    @Published var status: ConnectionStatus = .awaiting
    var gameManager = GameManager()

    
    func updateAnswers(for category: String, with answer: String) {
        dump.append(answer)
        print(dump)
    }

    func draw5Categories() -> [String] {
        return gameManager.randomCategories(categories: self.categories)
    }

    func drawLetter() -> String {
        return String(gameManager.randomLetter(letras: self.customAlphabet))
    }

}

extension GameService {
    var categories: [String] {
        return [
            "Nome",
            "Animal",
            "Cor",
            "Comida",
            "Bebida",
            "Lugar",
            "Objeto",
            "Profissão",
            "Filme",
            "Série",
            "Livro",
            "Personagem Famoso",
            "Marca",
            "Esporte",
            "Time",
            "Ator/Atriz",
            "Cantor(a)",
            "Banda",
            "Palavra em Inglês",
            "Doença",
            "Partes do Corpo",
            "App ou Site",
            "Celebridade",
            "Jogo",
            "Instrumento Musical",
            "Estilo Musical",
            "Doces/Sobremesas",
            "Verbo",
            "Adjetivo",
            "Coisa de Praia",
            "Coisa de Festa",
            "Fulano é..."

        ]

    }

    var customAlphabet: String
    { return "ABCDEFGHIJLMNOPQRSTUV"

    }
}
