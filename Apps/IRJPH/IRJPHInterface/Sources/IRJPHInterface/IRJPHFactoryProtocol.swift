//
//  IRJPHFactoryProtocol.swift
//  IRJPHInterface
//
//  Created by Ömer Faruk Öztürk on 23.02.2025.
//

import Foundation

@MainActor
public protocol IRJPHFactoryProtocol {
    func create() -> any IRJPHInterface
}
