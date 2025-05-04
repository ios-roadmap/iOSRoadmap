//
//  TextTransform.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 16.04.2025.
//

import Foundation

public enum TextTransform: CaseIterable {
    /// No transformation – preserves original text
    case none

    /// Converts all characters to UPPERCASE
    case uppercase

    /// Converts all characters to lowercase
    case lowercase

    /// Capitalises the first letter of each word
    case capitalized

    /// Converts text to snake_case
    case snakeCased

    /// Converts text to kebab-case
    case kebabCased

    public func apply(to input: String) -> String {
        switch self {
        case .none:
            return input
        case .uppercase:
            return input.uppercased()
        case .lowercase:
            return input.lowercased()
        case .capitalized:
            return input.capitalized
        case .snakeCased:
            return input.snakeCased()
        case .kebabCased:
            return input.kebabCased()
        }
    }
}
