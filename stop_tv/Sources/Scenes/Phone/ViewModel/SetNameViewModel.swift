//
//  SetNameViewModel.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//

import Foundation

class SetNameViewModel {
    var userName: String = ""

    func saveName() {
        UserDefaults.standard.set(userName, forKey: "yourName")
    }

    var savedName: String {
        UserDefaults.standard.string(forKey: "yourName") ?? ""
    }
}
