//
//  String+Normalise.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 26.04.2025.
//

import Foundation

// MARK: Purpose Canonise text for comparisons and indexing.

/// Diacritic/ligature folding, custom locale rules (e.g. “ß” → “ss”).
/// Unicode NFC/NFD/NFKC/NFKD transformations.
/// Homoglyph substitution (e.g. Cyrillic ‘а’ → Latin ‘a’).
/// Smart punctuation replacement (“…” → “…”, ““ → ")”.
/// Strip control characters and zero-width spaces.

public extension String {
    var normalised: String {
        folding(options: .diacriticInsensitive, locale: .current) //Remove accents and diacritics
            .replacingOccurrences(of: "ß", with: "SS")
            .uppercased()
    }
}
