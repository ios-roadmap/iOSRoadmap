//
//  ButtonStyle.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import UIKit

public enum ButtonStyle: CaseIterable {

    // Filled --------------------------------------------------------------
    case filledPrimary, filledSecondary, filledSuccess, filledWarning, filledDestructive
    // Outlined ------------------------------------------------------------
    case outlinedPrimary, outlinedSecondary, outlinedDestructive
    // Ghost ---------------------------------------------------------------
    case ghost
    // Link ----------------------------------------------------------------
    case link, linkUnderlined
    // Icon‑only -----------------------------------------------------------
    case iconOnly

    // MARK: - Tokens

    /// Typography choice per style
    public var typography: Typography {
        switch self {
        case .link, .linkUnderlined, .iconOnly:
            return .callout
        case .filledSecondary, .outlinedSecondary, .ghost:
            return .bodyMedium
        case .filledPrimary, .filledSuccess, .filledWarning, .filledDestructive,
             .outlinedPrimary, .outlinedDestructive:
            return .bodySemibold
        }
    }

    /// Text transform
    public var textTransform: TextTransform {
        switch self {
        case .filledDestructive, .outlinedDestructive: return .uppercase
        default:                                       return .none
        }
    }

    /// Horizontal gap between title & icon
    public var spacing: Spacing {
        switch self {
        case .link, .linkUnderlined: return .micro
        case .iconOnly:              return .none
        default:                     return .small
        }
    }

    /// Icon placement
    public var iconAlignment: IconAlignment {
        switch self {
        case .link, .linkUnderlined: return .trailing
        default:                     return .leading
        }
    }

    /// Fixed height (px)
    public var height: CGFloat {
        switch typography {
        case .body, .bodyMedium, .bodySemibold: return 40
        case .callout:                          return 36
        default:                                return 30   // caption / micro fall‑back
        }
    }

    /// Background colour
    public var backgroundColour: UIColor {
        switch self {
        case .filledPrimary:      return .systemBlue
        case .filledSecondary:    return .systemGray
        case .filledSuccess:      return .systemGreen
        case .filledWarning:      return .systemOrange
        case .filledDestructive:  return .systemRed
        default:                  return .clear
        }
    }

    /// Foreground (text & icon) colour
    public var foregroundColour: UIColor {
        switch self {
        case .filledPrimary,
             .filledSecondary,
             .filledSuccess,
             .filledWarning,
             .filledDestructive:
            return .white

        case .outlinedPrimary,
             .link,
             .linkUnderlined:     return .systemBlue

        case .outlinedSecondary,
             .ghost:              return .systemGray

        case .outlinedDestructive: return .systemRed

        case .iconOnly:            return .systemGray
        }
    }

    /// Border colour (`nil` ⇒ no border)
    public var borderColour: UIColor? {
        switch self {
        case .outlinedPrimary:     return .systemBlue
        case .outlinedSecondary:   return .systemGray
        case .outlinedDestructive: return .systemRed
        default:                   return nil
        }
    }

    /// Corner radius
    public var cornerRadius: CGFloat {
        switch self {
        case .iconOnly:
            // Full pill for square icon buttons
            return height / 2
        case .link, .linkUnderlined:
            // No background therefore no radius
            return 0
        default:
            return 8
        }
    }
}
