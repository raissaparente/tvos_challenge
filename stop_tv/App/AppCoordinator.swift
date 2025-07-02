//
//  AppCoordinator.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//
// escrever letra na voting,
// o componente bar tem que ser sempre do mesmo tamanho, cor amarela em vez de preta
// fontes
// nao ta aparecendo a rodada na votting
import UIKit

class AppCoordinator {
    let window: UIWindow
    let connectionManager: ConnectionManager
    let gameService = GameService()
    let matchManager = MatchManager()
    let roundVM: RoundViewModel!
    let votingVM: VotingViewModel!
    let hostLobbyVM: HostLobbyViewModel!
    

    init(window: UIWindow, username: String) {
        self.window = window
        self.connectionManager = ConnectionManager(username: username)
        self.roundVM = RoundViewModel(connectionManager: connectionManager, gameService: gameService)
        self.votingVM = VotingViewModel(round: roundVM)
        self.hostLobbyVM = HostLobbyViewModel(
            connectionManager: connectionManager,
            gameService: gameService,
            roundViewModel: roundVM,
            matchManager: matchManager,
            votingViewModel: votingVM
        )
    }
    
    func start() {
        let nav = UINavigationController()
        let idiom = UIDevice.current.userInterfaceIdiom
        if idiom == .tv {
            
//            let vc = HostLobbyViewController(viewModel: hostLobbyVM, coordinator: self)
            let vc = VotingTVViewController(viewModel: roundVM, coordinator: self, matchManager: matchManager, votingVM: votingVM)
            
//            let vc = FinalRankingViewController(coordinator: self, viewModel: roundVM, matchManager: matchManager)

            nav.viewControllers = [vc]
        } else {
            let vm = PlayerLobbyViewModel(
                connectionManager: connectionManager,
                gameService: gameService,
                roundViewModel: roundVM,
                votingViewModel: votingVM
            )
            let vc = PlayerLobbyViewController(viewModel: vm, coordinator: self)
//            let vc = VotingPhoneViewController(viewModel: roundVM, coordinator: self, votingVM: votingVM)

            nav.viewControllers = [vc]
        }
        window.rootViewController = nav
        window.makeKeyAndVisible()
        
    }
    
    //TV
    func showLobbyScreen_TV(from currentVC: UIViewController) {

        let lobbyVC = HostLobbyViewController(viewModel: hostLobbyVM, coordinator: self)
        currentVC.navigationController?.pushViewController(lobbyVC, animated: true)
    }
    
    func showGameInstruction_TV(from currentVC: UIViewController) {

        
        let instructionVC = GameInstructionViewController(viewModel: hostLobbyVM, coordinator: self)
        currentVC.navigationController?.pushViewController(instructionVC, animated: true)
    }
    
    func showLetterDraw_TV(from currentVC: UIViewController) {
        let vm = LetterDrawViewModel(connectionManager: connectionManager, gameService: gameService)
        
        let letterDrawVC = LetterDrawViewController(viewModel: vm, coordinator: self, matchManager: matchManager, gameService: gameService, roundVM: roundVM)
        currentVC.navigationController?.pushViewController(letterDrawVC, animated: true)
    }
    
    func showCategory_TV(from currentVC: UIViewController) {
        let roundTVVC = RoundTVViewController(viewModel: roundVM, matchManager: matchManager, coordinator: self)
        currentVC.navigationController?.pushViewController(roundTVVC, animated: true)
    }
    
    func showVoting_TV(from currentVC: UIViewController) {
        let votingTVVC = VotingTVViewController(viewModel: roundVM, coordinator: self, matchManager: matchManager, votingVM: votingVM)
        currentVC.navigationController?.pushViewController(votingTVVC, animated: true)
    }
    
    func showPartialRanking_TV(from currentVC: UIViewController) {
        let partialRankingVC = PartialRankingViewController(coordinator: self, viewModel: roundVM, matchManager: matchManager)
        currentVC.navigationController?.pushViewController(partialRankingVC, animated: true)
    }
    
    func showFinalRanking_TV(from currentVC: UIViewController) {
        let finalRankingVC = FinalRankingViewController(coordinator: self, viewModel: roundVM, matchManager: matchManager)
        currentVC.navigationController?.pushViewController(finalRankingVC, animated: true)
    }
    
    //Phone
    func showWaitingMessage_phone(from currentVC: UIViewController, type: WaitingType) {
        let vm = WaitingViewModel(
            connectionManager: connectionManager,
            gameService: gameService,
            type: type
        )
        
        let waitingVC = WaitingViewController(viewModel: vm, coordinator: self)
        currentVC.navigationController?.pushViewController(waitingVC, animated: true)
    }
    
    func showAnswer_phone(from currentVC: UIViewController) {
        
        let roundPhoneVC = RoundPhoneViewController(viewModel: roundVM, coordinator: self)
        currentVC.navigationController?.pushViewController(roundPhoneVC, animated: true)
    }
    
    func showVoting_phone(from currentVC: UIViewController) {

        let votingPhoneVC = VotingPhoneViewController(viewModel: roundVM, coordinator: self, votingVM: votingVM)
        currentVC.navigationController?.pushViewController(votingPhoneVC, animated: true)
    }
}
