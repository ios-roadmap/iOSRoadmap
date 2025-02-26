//
//  IRInjectedModels.swift
//  IRCore
//
//  Created by Ömer Faruk Öztürk on 23.02.2025.
//

import UIKit

//@propertyWrapper
//public struct IRLazyInjected<Service> {
//    private var service: Service?
//    private let container: IRDependencyContainer
//    
//    public init(container: IRDependencyContainer = .shared) {
//        self.container = container
//    }
//    
//    public var wrappedValue: Service {
//        mutating get {
//            if let service { return service }
//            
//            guard let resolvedService = container.resolve(Service.self) else {
//                fatalError("Service \(Service.self) could not be resolved.")
//            }
//            
//            if Service.self is AnyObject.Type, resolvedService as AnyObject === self as AnyObject {
//                fatalError("Circular dependency detected for \(Service.self).")
//            }
//            
//            service = resolvedService
//            return resolvedService
//        }
//    }
//}

