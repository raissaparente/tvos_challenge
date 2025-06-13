//
//  AppCoordinator.swift
//  stop_tv
//
//  Created by Raissa Bruna Parente on 12/06/25.
//

import UIKit

class AppCoordinator {
    let window: UIWindow

    let connectionManager = ConnectionManager()
    let gameService = GameService()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let nav = UINavigationController()

                #if os(tvOS)
                let vm = ConnectionInstructionViewModel(
                    connectionManager: connectionManager,
                    gameService: gameService
                )
                let vc = ConnectionInstructionViewController(viewModel: vm, coordinator: self)
                nav.viewControllers = [vc]
                #else
                let vm = PlayerLobbyViewModel(
                    connectionManager: connectionManager,
                    gameService: gameService
                )
                let vc = PlayerLobbyViewController(viewModel: vm, coordinator: self)
                nav.viewControllers = [vc]
                #endif

                window.rootViewController = nav
                window.makeKeyAndVisible()
    }

    func makeConnectionInstructionVC_TV() -> UIViewController {
        let vm = ConnectionInstructionViewModel(
            connectionManager: connectionManager,
            gameService: gameService
        )
        return ConnectionInstructionViewController(viewModel: vm, coordinator: self)
    }

    func showLobbyScreen(from currentVC: UIViewController) {
        let vm = HostLobbyViewModel(
            connectionManager: connectionManager,
            gameService: gameService
        )
        let lobbyVC = HostLobbyViewController(viewModel: vm, coordinator: self)
        currentVC.navigationController?.pushViewController(lobbyVC, animated: true)
    }
}
