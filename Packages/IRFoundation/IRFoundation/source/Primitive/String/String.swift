//
//  String.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import Foundation

public extension String {
    func snakeCased() -> String {
        return self
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
            .joined(separator: "_")
    }

    func kebabCased() -> String {
        return self
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
            .joined(separator: "-")
    }
}
