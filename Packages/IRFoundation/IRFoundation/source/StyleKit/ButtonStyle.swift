//
//  ButtonStyle.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//


import UIKit

/// Semantic button styles with distinct visual treatments.
/// Colours can be overridden externally through the builder API.
public enum ButtonStyle: CaseIterable {
    case filled
    case outlined
    case ghost
    case link
    case icon
    case onlyText   // purely textual – no background, no border

    // MARK: Tokens -------------------------------------------------------------

    public var typography: Typography {
        switch self {
        case .link, .onlyText: return .callout
        case .icon:            return .body(.medium)
        default:               return .body(.semibold)
        }
    }

    public var textTransform: TextTransform {
        switch self {
        case .link, .onlyText: return .none
        default:               return .uppercase
        }
    }

    public var spacing: Spacing {
        switch self {
        case .icon, .onlyText: return .none
        default:               return .small
        }
    }

    public var iconAlignment: IconAlignment {
        self == .link ? .trailing : .leading
    }

    public var height: CGFloat {
        typography == .callout ? 36 : 40
    }

    public var background: UIColor {
        switch self {
        case .filled: return Colors.accentPrimary
        case .ghost:  return Colors.backgroundElevated
        default:      return .clear
        }
    }

    public var foreground: UIColor {
        switch self {
        case .filled: return .white
        default:      return Colors.accentPrimary
        }
    }

    public var border: UIColor? {
        self == .outlined ? Colors.accentPrimary : nil
    }

    public var cornerRadius: CGFloat {
        switch self {
        case .icon:      return height / 2
        case .onlyText:  return 0
        default:         return 8
        }
    }
}
