//
//  ButtonStyle.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import Foundation

public enum ButtonStyle: Equatable {

    // Filled -----------------------------------------------------------------
    case filledPrimary      (iconAlignment: IconAlignment = .leading)
    case filledSecondary    (iconAlignment: IconAlignment = .leading)
    case filledSuccess      (iconAlignment: IconAlignment = .leading)
    case filledWarning      (iconAlignment: IconAlignment = .leading)
    case filledDestructive  (iconAlignment: IconAlignment = .leading)

    // Outlined ---------------------------------------------------------------
    case outlinedPrimary    (iconAlignment: IconAlignment = .leading)
    case outlinedSecondary  (iconAlignment: IconAlignment = .leading)
    case outlinedDestructive(iconAlignment: IconAlignment = .leading)

    // Ghost / subtle background ---------------------------------------------
    case ghost              (iconAlignment: IconAlignment = .leading)

    // Link‑style -------------------------------------------------------------
    case link                       // plain text link
    case linkUnderlined             // always underlined

    // Icon‑only --------------------------------------------------------------
    case iconOnly                   // square, no title
}

public extension ButtonStyle {

    /// Typography spec
    var fontSize: FontSize {
        switch self {
        case .link, .linkUnderlined: return .callout
        case .iconOnly:              return .callout
        default:                     return .body
        }
    }

    var fontType: FontType {
        switch self {
        case .filledPrimary,
             .filledSuccess,
             .filledWarning,
             .filledDestructive,
             .outlinedPrimary,
             .outlinedDestructive:
            return .semibold

        case .filledSecondary,
             .outlinedSecondary,
             .ghost:
            return .medium

        case .link, .linkUnderlined:
            return .regular

        case .iconOnly:
            return .regular
        }
    }

    /// Text transform policy
    var textTransform: TextTransform {
        switch self {
        case .filledDestructive,
             .outlinedDestructive:
            return .uppercase

        default:
            return .none
        }
    }

    /// Horizontal gap between title & icon
    var spacing: Spacing {
        switch self {
        case .link, .linkUnderlined: return .micro
        case .iconOnly:              return .none
        default:                     return .small
        }
    }

    /// Icon placement (determined once at init)
    var iconAlignment: IconAlignment {
        switch self {
        case let .filledPrimary(a),
             let .filledSecondary(a),
             let .filledSuccess(a),
             let .filledWarning(a),
             let .filledDestructive(a),
             let .outlinedPrimary(a),
             let .outlinedSecondary(a),
             let .outlinedDestructive(a),
             let .ghost(a):
            return a

        case .link, .linkUnderlined:
            return .trailing          // textual links read better

        case .iconOnly:
            return .leading           // N/A but consistent
        }
    }

    /// Fixed Auto‑Layout height
    var height: CGFloat {
        switch fontSize {
        case .largeTitle: return 64
        case .title1:     return 56
        case .title2:     return 48
        case .title3:     return 44
        case .body:       return 40
        case .callout:    return 36
        case .footnote:   return 30
        case .caption:    return 26
        }
    }

    // -----------------------------------------------------------------------
    // Colour & border tokens ↓ keep these as design‑system identifiers
    // to be mapped to actual UIColor in IRStyleKit.
    // -----------------------------------------------------------------------

    var backgroundToken: String {
        switch self {
        case .filledPrimary:      return "btnBg/primary"
        case .filledSecondary:    return "btnBg/secondary"
        case .filledSuccess:      return "btnBg/success"
        case .filledWarning:      return "btnBg/warning"
        case .filledDestructive:  return "btnBg/destructive"

        case .ghost:              return "btnBg/ghost"
        case .outlinedPrimary,
             .outlinedSecondary,
             .outlinedDestructive,
             .link, .linkUnderlined,
             .iconOnly:           return "btnBg/clear"
        }
    }

    var titleToken: String {
        switch self {
        case .filledDestructive,
             .outlinedDestructive: return "txt/destructive"

        case .link,
             .linkUnderlined:      return "txt/link"

        default:                  return "txt/standard"
        }
    }

    var borderToken: String? {
        switch self {
        case .outlinedPrimary:     return "border/primary"
        case .outlinedSecondary:   return "border/secondary"
        case .outlinedDestructive: return "border/destructive"
        default:                   return nil
        }
    }
}
