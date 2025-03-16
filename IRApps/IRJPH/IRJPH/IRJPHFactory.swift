//
//  IRJPHFactory.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 16.03.2025.
//

import Foundation
import IRJPHInterface

public final class IRJPHFactory: @preconcurrency IRJPHFactoryProtocol {
    
    public init() { }
    
    @MainActor
    public func create() -> any IRJPHInterface {
        return IRJPHCoordinator()
    }
}
