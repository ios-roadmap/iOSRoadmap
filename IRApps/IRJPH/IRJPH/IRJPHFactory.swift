//
//  IRJPHFactory.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 16.03.2025.
//

import UIKit
import IRJPHInterface

public class IRJPHFactory: IRJPHFactoryProtocol {
    
    public init() {}

    public func create() -> IRJPHInterface {
        IRJPHCoordinator()
    }
}

/*
 Bu sayede:

 IRJPHCoordinator weak olarak kaydedildiğinde hemen ARC tarafından silinmez.
 IRJPHFactory içinde strong bir referans tutulur.
 Resolve edilirken weak olarak gelir, ama factory içinde yaşadığı için ARC tarafından yok edilmez.
 */
