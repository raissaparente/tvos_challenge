//
//  ConnectionManager.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//
import MultipeerConnectivity
//first: infoplist - bonjour with _name._tcp/udp and local network string

extension String {
    static var serviceName = "stoptv"
}

class ConnectionManager: NSObject, ObservableObject { //nsobject bc its objc framework
    private lazy var advertiser: MCNearbyServiceAdvertiser = {
            MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: String.serviceName)
        }() //advertises the device availability to connect (has delegates)
    private lazy var browser: MCNearbyServiceBrowser = {
            MCNearbyServiceBrowser(peer: myPeerId, serviceType: String.serviceName)
        }() //searches for devices available to connect through wifi (has delegates)
    
    
    let serviceType = String.serviceName  //identify the service
    let session: MCSession //enables and manages communication among all peers
    let myPeerId: MCPeerID
    weak var game: GameService?
    
    @Published var availablePeers: [MCPeerID] = []
    @Published var connectedPeers: [MCPeerID] = []
    
    @Published var receivedInvite: Bool = false
    @Published var receivedInviteFrom: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    func setup(game: GameService) {
        self.game = game
    }

    
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
        advertiser.startAdvertisingPeer()
    }

    func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
    }
    
    func startBrowsing() {
        browser.startBrowsingForPeers()
    }

    func stopBrowsing() {
        browser.stopBrowsingForPeers()
        availablePeers.removeAll()
    }
    

    func invite(peer: MCPeerID) {
        browser.invitePeer(peer, to: session, withContext: nil, timeout: 30)
    }

    
    func send(gameAction: GameAction) {
        if !session.connectedPeers.isEmpty {
            do {
                if let data = gameAction.data() {
                    try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                }
            } catch {
                print("error sending \(error.localizedDescription)")
            }
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
            print("Peer \(peerID.displayName) changed state to \(state.rawValue)")
            print("Connected: \(self.connectedPeers)")
        }
    }
    
    //receives data from peer that needs to be responded - main funcs for the game
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let gameAction = try? JSONDecoder().decode(GameAction.self, from: data) {
            DispatchQueue.main.async {
                switch gameAction.action {
                case .sendAnswer:
                    if let category = gameAction.category, let answer = gameAction.answer {
                        self.game?.updateAnswers(for: category, with: answer)
                    }
                case .voteAnswer:
                    //TODO: CHANGE TO REAL FUNC
                    break
                case .changeStatus:
                    if let status = gameAction.status {
                        self.game?.status = status
                    }
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) { }
}

