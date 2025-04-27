//
//  ButtonStyle.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import UIKit

/// Semantic, design-system button styles.
///
/// Maps each visual style to typographic, colour, spacing and layout tokens.
/// Works hand-in-glove with the `Typography` nested-enum model.
public enum ButtonStyle: CaseIterable {

    // MARK: - Filled ------------------------------------------------------

    /// Solid background, brand-coloured.
    case filledPrimary, filledSecondary, filledSuccess, filledWarning, filledDestructive

    // MARK: - Outlined ----------------------------------------------------

    /// Transparent fill with 1-pt stroke.
    case outlinedPrimary, outlinedSecondary, outlinedDestructive

    // MARK: - Ghost -------------------------------------------------------

    /// No stroke, subtle background on highlight.
    case ghost

    // MARK: - Link --------------------------------------------------------

    /// Text-only button, behaves like a hyperlink.
    case link, linkUnderlined

    // MARK: - Icon-only ---------------------------------------------------

    /// Square button containing just an icon.
    case iconOnly

    // MARK: - Tokens ------------------------------------------------------

    /// Typography token per style.
    public var typography: Typography {
        switch self {
        case .link, .linkUnderlined, .iconOnly:
            return .callout
        case .filledSecondary, .outlinedSecondary, .ghost:
            return .body(.medium)
        case .filledPrimary, .filledSuccess, .filledWarning, .filledDestructive,
             .outlinedPrimary, .outlinedDestructive:
            return .body(.semibold)
        }
    }

    /// Text transform (e.g. uppercase for destructive states).
    public var textTransform: TextTransform {
        switch self {
        case .filledDestructive, .outlinedDestructive: return .uppercase
        default:                                       return .none
        }
    }

    /// Horizontal gap between title and icon.
    public var spacing: Spacing {
        switch self {
        case .link, .linkUnderlined: return .micro
        case .iconOnly:              return .none
        default:                     return .small
        }
    }

    /// Icon placement relative to the title.
    public var iconAlignment: IconAlignment {
        switch self {
        case .link, .linkUnderlined: return .trailing
        default:                     return .leading
        }
    }

    /// Fixed height (pt).
    public var height: CGFloat {
        switch typography {
        case .body:                               return 40
        case .body(.medium), .body(.semibold):    return 40
        case .callout:                            return 36
        default:                                  return 30
        }
    }

    /// Background colour token.
    public var background: UIColor {
        switch self {
        case .filledPrimary:     return Colors.accentPrimary
        case .filledSecondary:   return Colors.accentSecondary
        case .filledSuccess:     return Colors.success
        case .filledWarning:     return Colors.warning
        case .filledDestructive: return Colors.destructive
        default:                 return .clear
        }
    }

    /// Foreground (text / icon) colour token.
    public var foreground: UIColor {
        switch self {
        case .filledPrimary, .filledSecondary, .filledSuccess,
             .filledWarning, .filledDestructive:
            return .white
        case .ghost, .outlinedSecondary:
            return Colors.accentSecondary
        case .outlinedPrimary, .link, .linkUnderlined:
            return Colors.accentPrimary
        case .outlinedDestructive:
            return Colors.destructive
        case .iconOnly:
            return Colors.accentSecondary
        }
    }

    /// Border colour token (nil for borderless styles).
    public var border: UIColor? {
        switch self {
        case .outlinedPrimary:     return Colors.accentPrimary
        case .outlinedSecondary:   return Colors.accentSecondary
        case .outlinedDestructive: return Colors.destructive
        default:                   return nil
        }
    }

    /// Corner radius (pt).
    public var cornerRadius: CGFloat {
        switch self {
        case .iconOnly:
            /// Full pill for square icon buttons.
            return height / 2
        case .link, .linkUnderlined:
            /// No background; no rounding.
            return 0
        default:
            return 8
        }
    }
}
