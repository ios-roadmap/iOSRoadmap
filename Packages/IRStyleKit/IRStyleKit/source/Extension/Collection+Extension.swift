//
//  Collection+Extension.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 13.04.2025.
//

import Foundation

public extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
