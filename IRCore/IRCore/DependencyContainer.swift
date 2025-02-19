//
//  DependencyContainer.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 18.02.2025.
//
import Foundation

public actor DependencyContainer {
    
    public static let shared = DependencyContainer()
    
    private var services: [String: Any] = [:]

    public init() { }
    
    public func register<Service>(type: Service.Type, service: Any) {
        let key = String(describing: type)
        services[key] = service
    }
    
    public func resolve<Service>(type: Service.Type) -> Service? {
        let key = String(describing: type)
        return services[key] as? Service
    }
}
