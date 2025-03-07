//
//  IRDependencyContainer.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 18.02.2025.
//

import Foundation

@MainActor
public class IRDependencyContainer {
    public static let shared = IRDependencyContainer()
    
    private var services = [String: Any]()
    private var factories = [String: (isSingleton: Bool, factory: () -> Any)]()
    private var singletonCache = [String: Any]()
    
    private init() { }

    public func register<Service>(_ service: Service, for type: Service.Type) {
        services[String(describing: type)] = service
    }
    
    public func register<Service>(
        _ factory: @escaping @Sendable () -> Service,
        for type: Service.Type,
        asSingleton: Bool = false
    ) {
        let key = String(describing: type)
        factories[key] = (asSingleton, factory)
        if asSingleton { singletonCache[key] = nil }
    }
    
    public func resolve<Service>(_ type: Service.Type) -> Service? {
        let key = String(describing: type)
        
        if let instance = singletonCache[key] ?? services[key] {
            return instance as? Service
        }
        
        guard let (isSingleton, factory) = factories[key] else {
            return nil
        }
        
        let service = factory()
        
        if isSingleton {
            singletonCache[key] = service
        }
        
        return service as? Service
    }
    
    public func unregister<Service>(_ type: Service.Type) {
        let key = String(describing: type)
        services[key] = nil
        factories[key] = nil
        singletonCache[key] = nil
    }
    
    public func isRegistered<Service>(_ type: Service.Type) -> Bool {
        let key = String(describing: type)
        return services[key] != nil || factories[key] != nil
    }
    
    public func reset() {
        services.removeAll()
        factories.removeAll()
        singletonCache.removeAll()
    }
    
    public func debugPrintRegisteredServices() {
        debugPrint("Instances:", services.keys, "Factories:", factories.keys, "Singletons:", singletonCache.keys)
    }
}
