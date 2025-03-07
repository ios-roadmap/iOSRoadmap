//
//  Coordinator.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 18.02.2025.
//

import UIKit
import IRCommon

@MainActor
public protocol IRCoordinatorProtocol: AnyObject, Sendable {
    
    var navigationController: UINavigationController? { get set }
    var parentCoordinator: IRCoordinatorProtocol? { get set }
    var children: [any IRCoordinatorProtocol] { get set }
    
    @discardableResult
    func start() -> UIViewController
    
    @discardableResult
    func start(_ coordinator: IRCoordinatorProtocol) -> UIViewController
    
    func start(with window: UIWindow?)
    
    func startCoordinator(
        _ coordinator: IRCoordinatorProtocol,
        with method: CoordinatorPresentationMethod,
        animated: Bool,
        completion: IRVoidHandler?
    )
    
    func navigationControllerForPresentation() -> UINavigationController
}

public extension IRCoordinatorProtocol {
    func start(with window: UIWindow?) { }

    @discardableResult
    func start(_ coordinator: any IRCoordinatorProtocol) -> UIViewController {
        print("Child: \(coordinator) added to parent: \(self)")
        children.append(coordinator)
        coordinator.parentCoordinator = self
        return coordinator.start()
    }

    func startCoordinator(
        _ coordinator: any IRCoordinatorProtocol,
        with method: CoordinatorPresentationMethod,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        coordinator.navigationController = (method == .push) ? navigationController : coordinator.navigationControllerForPresentation()
        let initialVC = start(coordinator)

        switch method {
        case .push:
            navigationController?.pushViewController(initialVC, animated: animated)
        case .present(let style):
            coordinator.navigationController?.viewControllers = [initialVC]
            coordinator.navigationController?.modalPresentationStyle = style
            navigationController?.present(coordinator.navigationController!, animated: animated, completion: completion)
        }
    }

    func navigationControllerForPresentation() -> UINavigationController {
        UINavigationController()
    }
}


public enum CoordinatorPresentationMethod: Equatable {
    case push
    case present(UIModalPresentationStyle)

    public static func == (lhs: CoordinatorPresentationMethod, rhs: CoordinatorPresentationMethod) -> Bool {
        switch (lhs, rhs) {
        case (.push, .push):
            return true
        case (.present(let lhsStyle), .present(let rhsStyle)):
            return lhsStyle == rhsStyle
        default:
            return false
        }
    }
}
