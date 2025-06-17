//
//  GameService.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//
import Foundation
import StopPlay

public class GameService: ObservableObject {
    @Published var status: ConnectionStatus = .awaiting
    var gameManager = GameManager()

    

    func draw5Categories() -> [String] {
        print("draw 5 categorias chamasas")
        return gameManager.randomCategories(categories: self.categories)
    }

    func drawLetter() -> String {
        return String(gameManager.randomLetter(letras: self.customAlphabet))
    }

}

public extension GameService {
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
    {
        return "ABCDEFGHIJLMNOPQRSTUV"

    }
}
