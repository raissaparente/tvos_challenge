//
//  File.swift
//  stop_tv
//
//  Created by Júlia Saboya on 27/06/25.
//

import StopPlay
extension RoundViewModel {
    func mockAnswers() {
        let category = currentCategory
        answers[category] = [
            Response(text: "Rato"),
            Response(text: "Rinoceronte"),
            Response(text: "Régua"),
            Response(text: "Roupa"),
            Response(text: "Relógio")
        ]
    }

    func getAnswerString(from index: Int?) -> String {
        guard let index = index else {
            return "Index inválido"
        }

        guard let response = answers[currentCategory]?[safe: index] else {
            return "Resposta inválida"
        }

        return response.text



        func printAnswers() {
            print("\n📝 Respostas por categoria:")
            for (categoria, respostas) in answers {
                print("📚 Categoria: \(categoria)")
                for (index, resposta) in respostas.enumerated() {
                    print("   🔹 Resposta \(index + 1): \(resposta)")
                }
            }
            print("🔚 Fim das respostas\n")
        }
    }

}
