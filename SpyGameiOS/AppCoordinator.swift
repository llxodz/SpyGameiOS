//
//  AppCoordinator.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 26.03.2023.
//

import UIKit
import Combine

protocol MainNavigation: AnyObject {
    func goToNumberField(with model: SettingNumberFieldViewController.Model)
    func goToTimeField(with model: SettingsTimeFieldViewController.Model)
    func goToGame(with model: GameViewModel.Model)
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
    
    func goToNumberField(with model: SettingNumberFieldViewController.Model) {
        let vc = SettingNumberFieldViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.configure(with: model)
        navigationController.present(vc, animated: true)
    }
    
    func goToTimeField(with model: SettingsTimeFieldViewController.Model) {
        let vc = SettingsTimeFieldViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.configure(with: model)
        navigationController.present(vc, animated: true)
    }
    
    func goToGame(with model: GameViewModel.Model) {
        let vm = GameViewModel(with: model)
        let vc = GameViewController(viewModel: vm)
        vc.modalPresentationStyle = .fullScreen
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.navigationBar.tintColor = Asset.Colors.mainTextColor.color
        navigationController.pushViewController(vc, animated: true)
    }
}
