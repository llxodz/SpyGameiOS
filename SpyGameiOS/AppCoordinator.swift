//
//  AppCoordinator.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 26.03.2023.
//

import UIKit
import Combine

protocol MainNavigation: AnyObject {
    func goToNumberField()
    func goToTimeField()
    func goToGame()
}

// MARK: - AppCoordinator

final class AppCoordinator: Coordinator {
    
    // Dependencies
    var parentCoordinator: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    private let networkRepository: INetworkRepository
    
    // MARK: - Init
    
    init(navigationController: UINavigationController, networkRepository: INetworkRepository) {
        self.navigationController = navigationController
        self.networkRepository = networkRepository
    }
    
    // MARK: - Coordinator
    
    func start() {
        let vm = MainViewModel(navigation: self, networkRepository: networkRepository)
        let vc = MainViewController(viewModel: vm)
        navigationController.setViewControllers([vc], animated: false)
    }
}

// MARK: - MainNavigation

extension AppCoordinator: MainNavigation {
    
    func goToNumberField() {
        let vc = SettingNumberFieldViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.configure(with: SettingNumberFieldViewController.Model(
            title: L10n.SettingsCell.players,
            number: 4,
            updateNumber: PassthroughSubject<Int, Never>()
        ))
        navigationController.present(vc, animated: true)
    }
    
    func goToTimeField() {
        let vc = SettingsTimeFieldViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        navigationController.present(vc, animated: true)
    }
    
    func goToGame() {
        // TODO: go to gameVC
    }
}
