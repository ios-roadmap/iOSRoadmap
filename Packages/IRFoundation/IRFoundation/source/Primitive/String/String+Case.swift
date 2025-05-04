//
//  String+Case.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 26.04.2025.
//

import Foundation

// MARK: Purpose Handle every conceivable letter-case transformation.

/// Conversions: snake_case, kebab-case, camelCase, PascalCase, CONSTANT_CASE.
/// Utilities: capitalise first letter, lower-camel from upper, swap case, title-case respecting locale.
/// ASCII vs Unicode aware toggles to decide whether to break grapheme clusters.
/// In-place (mutating) and returning variants.

public extension String {

    // MARK: • snake_case  &  kebab-case
    func snakeCased() -> String {
        components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
            .joined(separator: "_")
    }

    func kebabCased() -> String {
        components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
            .joined(separator: "-")
    }

    // MARK: • lowerCamelCase → UpperCamelCase
    var capitalisedFirst: String {
        guard let first = first else { return self }
        return String(first).uppercased() + dropFirst()
    }
}
