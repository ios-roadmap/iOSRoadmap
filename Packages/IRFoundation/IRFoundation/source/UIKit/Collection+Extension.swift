//
//  Collection+Extension.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 29.04.2025.
//

import UIKit

public extension Collection {
    /// Safely accesses the element at the given index, returning `nil` if out of bounds.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
