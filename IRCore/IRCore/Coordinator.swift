//
//  Coordinator.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 18.02.2025.
//

import UIKit

public protocol IRCoordinator {
    var childCoordinators: [IRCoordinator] { get set }
    func start()
}
