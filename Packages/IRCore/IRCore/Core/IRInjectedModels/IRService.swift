//
//  IRService.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 9.04.2025.
//

import Foundation

@MainActor
@propertyWrapper
public struct IRService<Service> {
    private let scope: IRDependencyContainer.IRContainerScope
    private var service: Service?

    public init(scope: IRDependencyContainer.IRContainerScope = .service) {
        self.scope = scope
    }

    public var wrappedValue: Service {
        mutating get {
            if let service {
                return service
            }
            let resolved: Service = IRDependencyContainer.shared.resolve(scope)
            self.service = resolved
            return resolved
        }
    }
}
