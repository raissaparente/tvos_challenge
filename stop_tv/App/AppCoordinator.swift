//
//  AppCoordinator.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//

import UIKit

class AppCoordinator {
    let window: UIWindow
    let connectionManager: ConnectionManager
    let gameService = GameService()
    let roundVM: RoundViewModel!

    init(window: UIWindow, username: String) {
        self.window = window
        self.connectionManager = ConnectionManager(username: username)
        self.roundVM = RoundViewModel(connectionManager: connectionManager, gameService: gameService)
    }

    func start() {
        let nav = UINavigationController()
        let idiom = UIDevice.current.userInterfaceIdiom
        if idiom == .pad {
            let vc = VotingTVViewController(viewModel: roundVM, coordinator: self)

//            let vc = ConnectionInstructionViewController(coordinator: self)
            nav.viewControllers = [vc]
        } else {
            let vm = PlayerLobbyViewModel(
                connectionManager: connectionManager,
                gameService: gameService,
                roundViewModel: roundVM
            )
//            let vc = PlayerLobbyViewController(viewModel: vm, coordinator: self)
            let vc = VotingPhoneViewController(viewModel: roundVM, coordinator: self)

            nav.viewControllers = [vc]
        }
        window.rootViewController = nav
        window.makeKeyAndVisible()

    }

    //TV
    func showLobbyScreen_TV(from currentVC: UIViewController) {
        let vm = HostLobbyViewModel(
            connectionManager: connectionManager,
            gameService: gameService,
            roundViewModel: roundVM
        )
        let lobbyVC = HostLobbyViewController(viewModel: vm, coordinator: self)
        currentVC.navigationController?.pushViewController(lobbyVC, animated: true)
    }

    func showGameInstruction_TV(from currentVC: UIViewController) {
        let instructionVC = GameInstructionViewController(coordinator: self)
        currentVC.navigationController?.pushViewController(instructionVC, animated: true)
    }

    func showLetterDraw_TV(from currentVC: UIViewController) {
        let vm = LetterDrawViewModel(connectionManager: connectionManager, gameService: gameService)

        let letterDrawVC = LetterDrawViewController(viewModel: vm, coordinator: self, gameService: gameService, roundVM: roundVM)
        currentVC.navigationController?.pushViewController(letterDrawVC, animated: true)
    }

    func showCategory_TV(from currentVC: UIViewController) {
        let roundTVVC = RoundTVViewController(viewModel: roundVM, coordinator: self)
        currentVC.navigationController?.pushViewController(roundTVVC, animated: true)
    }
    
    func showVoting_TV(from currentVC: UIViewController) {
        let roundTVVC = VotingTVViewController(viewModel: roundVM, coordinator: self)
        currentVC.navigationController?.pushViewController(roundTVVC, animated: true)
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

        let votingPhoneVC = VotingPhoneViewController(viewModel: roundVM, coordinator: self)
        currentVC.navigationController?.pushViewController(votingPhoneVC, animated: true)
    }
}
