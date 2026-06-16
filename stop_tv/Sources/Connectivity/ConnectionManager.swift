//
//  ConnectionManager.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//
import MultipeerConnectivity

extension String {
    static var serviceName = "stoptv"
}

class ConnectionManager: NSObject, ObservableObject {
    private lazy var advertiser: MCNearbyServiceAdvertiser = {
        MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: String.serviceName)
    }()
    private lazy var browser: MCNearbyServiceBrowser = {
        MCNearbyServiceBrowser(peer: myPeerId, serviceType: String.serviceName)
    }()
    
    
    let serviceType = String.serviceName
    let session: MCSession
    let myPeerId: MCPeerID
    var isHost = false
    var onEvent: ((GameEvent) -> Void)?

    @Published var availablePeers: [MCPeerID] = []
    @Published var connectedPeers: [MCPeerID] = []
    
    @Published var receivedInvite: Bool = false
    @Published var receivedInviteFrom: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    
    init(username: String) {
        myPeerId = MCPeerID(displayName: username)
        session = MCSession(peer: myPeerId)
        super.init()
        session.delegate = self
        advertiser.delegate = self
        browser.delegate = self
    }
    
    deinit {
        stopAdvertising()
        stopBrowsing()
    }
    
    func startAdvertising() {
        isHost = false
        advertiser.startAdvertisingPeer()
    }
    
    func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
    }
    
    func startBrowsing() {
        isHost = true
        browser.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        browser.stopBrowsingForPeers()
        availablePeers.removeAll()
    }
    
    
    func invite(peer: MCPeerID) {
        browser.invitePeer(peer, to: session, withContext: nil, timeout: 30)
    }
    
    
    func send<T: Codable>(gameAction: GameAction<T>) {
        guard !session.connectedPeers.isEmpty else { return }
        
        do {
            if let data = gameAction.data() {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                print("📤 Enviado: \(gameAction)")
            }
        } catch {
            print("❌ Erro ao enviar: \(error.localizedDescription)")
        }
    }
}

extension ConnectionManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async {
            self.receivedInvite = true
            self.receivedInviteFrom = peerID
            self.invitationHandler = invitationHandler
        }
    }
}

extension ConnectionManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            if !self.availablePeers.contains(peerID) {
                self.availablePeers.append(peerID)
                print("🔍 Found peer: \(peerID.displayName)")
                
                
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.availablePeers.removeAll { $0 == peerID }
        }
    }
}

extension ConnectionManager: MCSessionDelegate {
    //session state updates published properties
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            self.connectedPeers = session.connectedPeers
        }
    }
    
    //receives data from peer that needs to be responded - main funcs for the game
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            guard let typeHint = try? JSONDecoder().decode(GameActionTypeWrapper.self, from: data) else {
                print("❌ Falha ao detectar tipo da ação")
                return
            }

            let event: GameEvent?

            switch typeHint.type {
            case .sendAnswer:
                if let action = try? JSONDecoder().decode(GameAction<SendAnswerPayload>.self, from: data) {
                    event = .didReceiveAnswer(answer: action.payload.answer, from: action.payload.playerName.name)
                } else {
                    event = nil
                }
            case .voteAnswer:
                if let action = try? JSONDecoder().decode(GameAction<VotePayload>.self, from: data) {
                    event = .didReceiveVote(category: action.payload.category,
                                            voterName: action.payload.voterName,
                                            selectedIndexes: action.payload.selectedIndexes)
                } else {
                    event = nil
                }
            case .setAnswers:
                if let action = try? JSONDecoder().decode(GameAction<SetAnswersPayload>.self, from: data) {
                    event = .didReceiveSetAnswers(answers: action.payload.answers)
                } else {
                    event = nil
                }
            case .changeStatus:
                if let action = try? JSONDecoder().decode(GameAction<ChangeStatusPayload>.self, from: data) {
                    event = .didReceiveChangeStatus(status: action.payload.status)
                } else {
                    event = nil
                }
            case .changeCategory:
                event = .didReceiveChangeCategory
            case .setCategories:
                if let action = try? JSONDecoder().decode(GameAction<SetCategoriesPayload>.self, from: data) {
                    event = .didReceiveSetCategories(categories: action.payload.categories)
                } else {
                    event = nil
                }
            }

            if let event {
                self.onEvent?(event)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) { }
}

