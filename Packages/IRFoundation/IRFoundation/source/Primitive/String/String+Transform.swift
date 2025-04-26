//
//  String+Transform.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 26.04.2025.
//

import Foundation

// MARK: Purpose General text reshaping.

/// trim, collapseWhitespace, removeNewlines.
/// Word-level actions: reverse words, sort words, unique words.
/// Sentence-level actions: sentence splitting, reversing sentence order.
/// Name helpers: initials, first/last name extraction.
/// Multibyte-safe substring helpers (prefix, suffix, mid, chunking by grapheme).

public extension String {

    /// "Ömer Faruk Öztürk" → "OO"
    var initials: String {
        let parts = components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }

        guard let f = parts.first?.first,
              let l = parts.last?.first else { return "" }

        return "\(f)\(l)".uppercased()
    }

    /// leading / trailing whitespace & new-lines
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// "swift is fun" → "fun is swift"
    var reversedWords: String {
        components(separatedBy: .whitespaces)
            .reversed()
            .joined(separator: " ")
    }
}
