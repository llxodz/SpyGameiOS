//
//  Coordinator.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 26.03.2023.
//

import UIKit

public protocol Coordinator {
    
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
