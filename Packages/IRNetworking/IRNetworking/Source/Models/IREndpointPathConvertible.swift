//
//  IREndpointPathConvertible.swift
//  IRNetworking
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

public protocol IREndpointPathConvertible {
    var rawValue: String { get }
    var path: String { get }
}

public extension IREndpointPathConvertible {
    var path: String { rawValue }
}
