//
//  File.swift
//  stop_tv
//
//  Created by Júlia Saboya on 27/06/25.
//

import StopPlay
extension RoundViewModel {
    func getAnswerString(from index: Int?) -> String {
        guard let index = index else {
            return "Index inválido"
        }

        guard let response = answers[currentCategory]?[safe: index] else {
            return "Resposta inválida"
        }

        return response.text
    }
}
