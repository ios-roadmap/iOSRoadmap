//
//  ButtonStyle.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import Foundation

public enum ButtonStyle {
    case primaryColorLowEmphasisLargeText
    case primaryColorMediumEmphasisLargeText
    case primaryColorHighEmphasisLargeText
    
    case secondaryColorLowEmphasisLargeText
    case secondaryColorMediumEmphasisLargeText
    case secondaryColorHighEmphasisLargeText
    
    var isSmall: Bool {
        switch self {
        case .secondaryColorLowEmphasisLargeText,
                .secondaryColorMediumEmphasisLargeText,
                .secondaryColorHighEmphasisLargeText:
            return true
        default:
            return false
        }
    }
    
    var isMediumEnphasis: Bool {
        switch self {
        case .primaryColorMediumEmphasisLargeText,
                .secondaryColorMediumEmphasisLargeText:
            return true
        default:
            return false
        }
    }
    
    var isHighEmphasis: Bool {
        switch self {
        case .primaryColorHighEmphasisLargeText,
                .secondaryColorHighEmphasisLargeText:
            return true
        default:
            return false
        }
    }
}
