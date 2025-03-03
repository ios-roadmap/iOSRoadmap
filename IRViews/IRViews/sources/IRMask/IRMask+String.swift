//
//  IRMask+String.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 28.02.2025.
//

import Foundation

// MARK: - String Extension
public extension String {
    func onlyDigits() -> String {
        return self.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
    }
    
    var containsEmoji: Bool {
        return self.unicodeScalars.contains { $0.properties.isEmoji && ($0.value > 0x238C || $0.properties.isEmojiPresentation) }
    }
    
    func lastDigitIndex() -> Int? {
        for i in stride(from: count - 1, through: 0, by: -1) {
            let idx = index(startIndex, offsetBy: i)
            if self[idx].isNumber {
                return i
            }
        }
        return nil
    }
    
    func indices(for character: Character) -> [Int] {
        enumerated().compactMap { $1 == character ? $0 : nil }
    }
}
