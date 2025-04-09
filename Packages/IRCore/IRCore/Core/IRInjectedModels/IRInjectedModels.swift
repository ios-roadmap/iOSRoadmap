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
    private let container: IRDependencyContainer

    public init(container: IRDependencyContainer = .shared) {
        self.container = container
    }

    public var wrappedValue: Service {
        mutating get {
            if let service { return service } // ✅ daha önce resolve edildiyse cache'liyoruz
            let resolved: Service = container.resolve()
            service = resolved
            return resolved
        }
    }
    
    // 👉 Bu tam anlamıyla lazy var gibi davranıyor, ama dependency injection ve property wrapper kombinasyonuyla.
}


