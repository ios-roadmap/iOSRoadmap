//
//  ButtonStyle.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import UIKit

public enum ButtonStyle: CaseIterable {
    case primaryLargeFilled
    case primarySmallOutline
    case secondaryLargeTextOnly
    case secondarySmallFilled
    case destructiveLargeFilled
    case destructiveSmallTextOnly
    case iconLeadingSmall
    case iconTrailingLarge

    // MARK: - Visual Properties

    public var fontType: FontType {
        switch self {
        case .destructiveLargeFilled: return .bold
        case .secondaryLargeTextOnly: return .medium
        default: return .semibold
        }
    }

    public var fontSize: FontSize {
        switch self {
        case .primarySmallOutline,
             .secondarySmallFilled,
             .destructiveSmallTextOnly,
             .iconLeadingSmall:
            return .callout
        default:
            return .body
        }
    }

    public var cornerRadius: Spacing {
        switch self {
        case .iconLeadingSmall:
            return .large
        default:
            return .tiny
        }
    }

    //TODO: ömer spacing
    public var height: CGFloat {
        switch self {
        case .primarySmallOutline,
             .secondarySmallFilled,
             .destructiveSmallTextOnly,
             .iconLeadingSmall:
            return 40
        default:
            return 56
        }
    }

    public var padding: UIEdgeInsets {
        switch self {
        case .iconLeadingSmall:
            return .init(top: 6, left: 6, bottom: 6, right: 6)
        default:
            return .init(top: 12, left: 16, bottom: 12, right: 16)
        }
    }

    public var spacing: Spacing {
        switch self {
        case .iconLeadingSmall: return .micro
        case .iconTrailingLarge: return .small
        default: return .tiny
        }
    }

    public var hasText: Bool {
        switch self {
        case .iconLeadingSmall: return false
        default: return true
        }
    }

    public var hasIcon: Bool {
        switch self {
        case .iconLeadingSmall, .iconTrailingLarge: return true
        default: return false
        }
    }

    public var iconAlignment: IconAlignment {
        switch self {
        case .iconTrailingLarge: return .trailing
        default: return .leading
        }
    }
}
