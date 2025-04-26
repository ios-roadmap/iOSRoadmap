//
//  File.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 26.04.2025.
//

import Foundation

private extension String {

    /// `Ömer Faruk Öztürk` → `OO`
    var initials: String {
        let parts = components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }

        guard
            let first = parts.first?.first,
            let last  = parts.last?.first
        else { return "" }

        return "\(first)\(last)".uppercased()
    }

    /// Removes diacritics and locale-speciﬁc glyphs → ASCII uppercase.
    var normalised: String {
        folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: "ß", with: "SS")
            .uppercased()
    }
}
