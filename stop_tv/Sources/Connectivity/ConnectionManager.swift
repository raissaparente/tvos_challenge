//
//  ConnectionManager.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 11/06/25.
//
import MultipeerConnectivity
//import StopPlay

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
    weak var round: RoundViewModel?
    weak var votingVM: VotingViewModel?


    @Published var availablePeers: [MCPeerID] = []
    @Published var connectedPeers: [MCPeerID] = []
    
    @Published var receivedInvite: Bool = false
    @Published var receivedInviteFrom: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    
    func setup(game: GameService, round: RoundViewModel, votingVM: VotingViewModel) {
        self.game = game
        self.round = round
        self.votingVM = votingVM
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
            
            switch typeHint.type {
                
            case .sendAnswer:
                if let action = try? JSONDecoder().decode(GameAction<SendAnswerPayload>.self, from: data) {
                    let answer = action.payload.answer
                    let player = action.payload.playerName
                    
                    self.round?.saveAnswer(answer)
                    self.round?.playersWhoAnswered.append(player.name)
                }
                
            case .voteAnswer:
                if let action = try? JSONDecoder().decode(GameAction<VotePayload>.self, from: data) {
                    let category = action.payload.category
                    let voterName = action.payload.voterName
                    let selectedIndexes = action.payload.selectedIndexes


                    self.votingVM?.appendRemotePlayerVote(
                        voterName: voterName,
                        selectedIndexes: selectedIndexes,
                        category: category
                    )
                }
            case .setAnswers:
                if let action = try? JSONDecoder().decode(GameAction<SetAnswersPayload>.self, from: data) {
                    self.round?.answers = action.payload.answers
                }

            case .changeStatus:
                if let action = try? JSONDecoder().decode(GameAction<ChangeStatusPayload>.self, from: data) {
                    let status = action.payload.status
                    self.game?.status = status
                }
                
            case .changeCategory:
                if let action = try? JSONDecoder().decode(GameAction<EmptyPayload>.self, from: data) {
                    self.round?.advanceCategory()
                }
                
            case .setCategories:
                if let action = try? JSONDecoder().decode(GameAction<SetCategoriesPayload>.self, from: data) {
                    let categories = action.payload.categories
                    self.round?.categories = categories
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) { }
}

