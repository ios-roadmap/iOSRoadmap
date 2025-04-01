//
//  IRDashboardFactoryProtocol.swift
//  IRDashboardInterface
//
//  Created by Ömer Faruk Öztürk on 23.02.2025.
//

import Foundation

@MainActor
public protocol IRDashboardFactoryProtocol {
    func create() -> any IRDashboardInterface
}
