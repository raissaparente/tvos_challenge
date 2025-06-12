//
//  HostLobbyViewModel.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//

import Combine
import MultipeerConnectivity

class HostLobbyViewModel {
    @Published var selectedPeers: [MCPeerID] = []

    func toggleSelection(for peer: MCPeerID) {
        if selectedPeers.contains(peer) {
            selectedPeers.removeAll { $0 == peer }
        } else {
            selectedPeers.append(peer)
        }
    }
}
