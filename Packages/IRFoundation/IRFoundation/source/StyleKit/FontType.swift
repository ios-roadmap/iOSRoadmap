//
//  FontType.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 16.04.2025.
//

import UIKit

public enum FontType: CaseIterable {
    /// System font – Regular weight (default)
    case regular

    /// System font – Medium weight (emphasis without bolding)
    case medium

    /// System font – Semibold weight (used for prominent text)
    case semibold

    /// System font – Bold weight (strong emphasis)
    case bold

    /// Monospaced font – Equal character width, ideal for code or digits
    case monospaced

    public func font(ofSize pointSize: CGFloat, textStyle: UIFont.TextStyle? = nil) -> UIFont {
        let baseFont: UIFont
        switch self {
        case .regular:
            baseFont = .systemFont(ofSize: pointSize, weight: .regular)
        case .medium:
            baseFont = .systemFont(ofSize: pointSize, weight: .medium)
        case .semibold:
            baseFont = .systemFont(ofSize: pointSize, weight: .semibold)
        case .bold:
            baseFont = .systemFont(ofSize: pointSize, weight: .bold)
        case .monospaced:
            baseFont = .monospacedSystemFont(ofSize: pointSize, weight: .regular)
        }

        // Apply dynamic type scaling if textStyle is provided
        guard let style = textStyle else { return baseFont }
        return UIFontMetrics(forTextStyle: style).scaledFont(for: baseFont)
    }
}
