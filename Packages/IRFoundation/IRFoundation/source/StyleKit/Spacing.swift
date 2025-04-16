//
//  Padding.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 16.04.2025.
//

import Foundation

public enum Spacing: CGFloat, CaseIterable {
    /// 0pt – No spacing
    case none = 0

    /// 1pt – Hairline spacing, barely visible
    case hair = 1

    /// 4pt – Micro spacing, for tight elements
    case micro = 4

    /// 8pt – Tiny spacing, minor separations
    case tiny = 8

    /// 12pt – Small spacing, common for compact layouts
    case small = 12

    /// 16pt – Medium spacing, default padding
    case medium = 16

    /// 24pt – Large spacing, between major blocks
    case large = 24

    /// 32pt – Huge spacing, for distinct separation
    case huge = 32

    /// Raw spacing value as CGFloat
    public var value: CGFloat { rawValue }
}
