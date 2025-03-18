//
//  IRInjectedModels.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 23.02.2025.
//

@MainActor
@propertyWrapper
public struct IRLazyInjected<Service: Sendable> {
    private var service: Service?
    private let container: IRCoreDependencyContainer

    public init(container: IRCoreDependencyContainer = .shared) {
        self.container = container
    }

    public var wrappedValue: Service {
        mutating get {
            if let service { return service }

            guard let resolvedService: Service = container.resolve() else {
                fatalError("❗ Service of type \(Service.self) could not be resolved!")
            }

            service = resolvedService
            return service!
        }
    }

    public mutating func asyncWrappedValue() async -> Service {
        if let service { return service }

        guard let resolvedService: Service = container.resolve() else {
            fatalError("❗ Service of type \(Service.self) could not be resolved!")
        }

        service = resolvedService
        return service!
    }
}
