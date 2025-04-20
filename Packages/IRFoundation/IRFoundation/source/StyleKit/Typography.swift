//
//  Typography.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 16.04.2025.
//

import UIKit

/// Centralised, design‑system source‑of‑truth for every text role your app
/// should ever need. Keep it self‑contained and resist the urge to hard‑code
/// ad‑hoc fonts elsewhere.
public enum Typography: CaseIterable {

    // MARK: - Display / Hero
    /// Immersive, billboard‑sized copy for onboarding or hero banners
    /// – 40 pt Regular
    case display1

    // MARK: - Large Titles
    /// Primary screen heading (large nav bar, Settings root, etc.)
    /// – 34 pt Regular
    case largeTitle

    // MARK: - Titles
    /// Section header, top hierarchy
    /// – 28 pt Regular
    case title1
    /// Section header, mid hierarchy
    /// – 22 pt Regular
    case title2
    /// Section header, lowest hierarchy
    /// – 20 pt Regular
    case title3

    // MARK: - Headlines
    /// Prominent single‑line heading inside cards or lists
    /// – 17 pt Semibold
    case headline
    /// Secondary heading that follows a headline
    /// – 15 pt Regular
    case subheadline

    // MARK: - Body
    /// Default paragraph text
    /// – 17 pt Regular
    case body
    /// Body with medium emphasis (subtle highlight)
    /// – 17 pt Medium
    case bodyMedium
    /// Body with strong emphasis (but not full bold)
    /// – 17 pt Semibold
    case bodySemibold

    // MARK: - Callout
    /// Supporting one‑liners or in‑cell meta
    /// – 16 pt Regular
    case callout

    // MARK: - Footnotes & Captions
    /// Disclaimers, timestamps, metadata
    /// – 13 pt Regular
    case footnote
    /// Image captions, table headers
    /// – 12 pt Regular
    case caption1
    /// Micro‑labels under controls or icons
    /// – 11 pt Regular
    case caption2

    // MARK: - Numerics
    /// Monospaced digits for timers, code snippets, counters
    /// – 17 pt Regular (Monospaced)
    case monospacedDigit

    // MARK: - Controls
    /// Button labels
    /// – 17 pt Semibold
    case button
    /// Tab‑bar item titles
    /// – 10 pt Regular
    case tabBar
    /// Compact navigation‑bar titles / back‑button text
    /// – 17 pt Regular
    case navigationBar

    // MARK: - Badges
    /// Pill‑style badge numbers or status pills
    /// – 13 pt Semibold
    case badge
    /// Ultra‑small badge inside icons (network bars, tiny counters)
    /// – 10 pt Regular
    case micro

    var pointSize: CGFloat {
        switch self {
        case .display1:                  return 40
        case .largeTitle:                return 34
        case .title1:                    return 28
        case .title2:                    return 22
        case .title3:                    return 20
        case .headline:                  return 17
        case .subheadline:               return 15
        case .body, .bodyMedium,
             .bodySemibold,
             .monospacedDigit,
             .button,
             .navigationBar:             return 17
        case .callout:                   return 16
        case .footnote:                  return 13
        case .caption1:                  return 12
        case .caption2:                  return 11
        case .tabBar, .micro:            return 10
        case .badge:                     return 13
        }
    }

    var weight: UIFont.Weight {
        switch self {
        case .headline, .bodySemibold, .button, .badge:
            return .semibold
        case .bodyMedium:
            return .medium
        default:
            return .regular
        }
    }

    var textStyle: UIFont.TextStyle {
        switch self {
        case .display1, .largeTitle:     return .largeTitle
        case .title1:                    return .title1
        case .title2:                    return .title2
        case .title3:                    return .title3
        case .headline:                  return .headline
        case .subheadline:               return .subheadline
        case .body, .bodyMedium,
             .bodySemibold,
             .monospacedDigit:           return .body
        case .callout:                   return .callout
        case .footnote:                  return .footnote
        case .caption1:                  return .caption1
        case .caption2:                  return .caption2
        case .button:                    return .body         // Dynamic‑Type ties button to .body
        case .tabBar, .micro:            return .caption2
        case .navigationBar:             return .headline
        case .badge:                     return .caption2
        }
    }

    /// Returns a Dynamic‑Type‑aware `UIFont` for the style.
    public func font() -> UIFont {
        let base: UIFont
        if self == .monospacedDigit {
            base = .monospacedSystemFont(ofSize: pointSize, weight: weight)
        } else {
            base = .systemFont(ofSize: pointSize, weight: weight)
        }
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: base)
    }
}
