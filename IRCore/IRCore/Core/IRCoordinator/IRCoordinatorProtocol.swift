//
//  Coordinator.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 18.02.2025.
//

import UIKit
import IRCommon

@MainActor
public protocol IRCoreCoordinatorProtocol: Sendable {
    func start()
    func setupWindow(windowScene: UIWindowScene)
    func startChildCoordinator(
        _ coordinator: IRCoreCoordinatorProtocol,
        with method: IRCoreCoordinator.IRCoordinatorPresentationMethod,
        animated: Bool,
        completion: (() -> Void)?
    )
    func stopChildCoordinator()
}

open class IRCoreCoordinator: IRCoreCoordinatorProtocol {
    
    public var navigationController: UINavigationController?
    private let navigationDelegate = IRNavigationControllerDelegate()
    
    private weak var parentCoordinator: IRCoreCoordinator?
    public var childCoordinator: IRCoreCoordinator?
    
    public init(parent: IRCoreCoordinator? = nil) {
        self.parentCoordinator = parent
    }
    
    public enum IRCoordinatorPresentationMethod: Equatable {
        case push
        case present(UIModalPresentationStyle = .automatic)
    }

    open func start() {
        fatalError("Subclasses should implement `start()`")
    }

    open func navigate(
        to viewController: UIViewController,
        with method: IRCoordinatorPresentationMethod = .push,
        animated: Bool = true
    ) {
        switch method {
        case .push:
            navigationController?.pushViewController(viewController, animated: animated)
        case .present(let style):
            let navController = UINavigationController(rootViewController: viewController)
            navController.modalPresentationStyle = style
            navigationController?.present(navController, animated: animated)
        }
    }


    open func pop(animated: Bool = true) {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            navigationController?.popViewController(animated: animated)
        } else {
            stopChildCoordinator()
        }
    }

    public var window: UIWindow?
    public func setupWindow(windowScene: UIWindowScene) {
        navigationController = UINavigationController()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        
        start()
    }

    public func startChildCoordinator(
        _ coordinator: IRCoreCoordinatorProtocol,
        with method: IRCoordinatorPresentationMethod,
        animated: Bool,
        completion: (() -> Void)? = nil
    ) {
        guard let concreteCoordinator = coordinator as? IRCoreCoordinator else {
            fatalError("Coordinator is not a subclass of IRCoreCoordinator")
        }

        // Koordinatörü Dependency Container’a strong olarak kaydediyoruz
        IRCoreDependencyContainer.shared.register(concreteCoordinator, strong: true)
        
        switch method {
        case .push:
            concreteCoordinator.navigationController = self.navigationController
            concreteCoordinator.start()
        case .present(let style):
            let navController = UINavigationController(rootViewController: concreteCoordinator.navigationController!)
            navController.modalPresentationStyle = style
            self.navigationController?.present(navController, animated: animated)
        }
    }

    public func stopChildCoordinator() {
        childCoordinator?.navigationController?.dismiss(animated: true)

        // Dependency Container’dan koordinatörü kaldır
        if let coordinator = childCoordinator {
            IRCoreDependencyContainer.shared.unregister(type(of: coordinator))
        }

        childCoordinator = nil
        IRCoreDependencyContainer.shared.debugPrint()
    }
}
