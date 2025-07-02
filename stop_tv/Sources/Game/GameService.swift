//
//  GameService.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//
import Foundation
import StopPlay
import MultipeerConnectivity

public class GameService: ObservableObject {
    @Published var status: ConnectionStatus = .awaiting
    var gameManager = GameManager()

    func draw5Categories() -> [String] {
        print("game service")
        print(gameManager.randomCategories(categories: self.categories))
        return gameManager.randomCategories(categories: self.categories)
    }

    func drawLetter() -> String {
        return String(gameManager.randomLetter(letras: self.customAlphabet))
    }
    
    func makePlayers(from peers: [MCPeerID]) -> [Player] {
        return peers.map { Player(name: $0.displayName, id: UUID(), points: 0)}
    }
    
    func makeRanking(from players: [Player]) -> [Player] {
        return gameManager.ranking(players: players)
    }

}

public extension GameService {
    var categories: [String] {
        return [
            "Superpoder inútil",
            "Problema da terapia",
            "Coisa que está fora do meu orçamento",
            "Motivo de cancelamento",
            "Deveria ser crime",
            "O novo Prêmio Nobel",
            "Formas de morrer",
            "Motivo pra beber",
            "Futuro esporte olímpico",
            "Subcelebridade",
            "Nome de remédio",
            "Nome muito brasileiro",
            "Aplicativo",
            "Comida que a nutricionista aprova",
            "Dá pra botar num cachorro quente",
            "Nome de idoso",
            "Tem no banheiro",
            "Chamaria pro churrasco",
            "Coisas redondas",
            "Coisas de inverno",
            "Palavra de 5 letras",
            "Nome de música",
            "Tenho medo de...",
            "Hoje eu vou...",
            "Pessoa histórica",
            "Coisa de religião",
            "Fantasias de carnaval"
        ]

    }

    var customAlphabet: String
    {
        return "ABCDEFGHIJLMNOPQRSTUV"

    }
}
