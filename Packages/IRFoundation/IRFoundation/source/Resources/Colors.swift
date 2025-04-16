//
//  Colors.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 16.04.2025.
//

import UIKit

public enum Colors: CaseIterable {
    case primary
    case secondary
    case accent
    case error
    
    var uiColor: UIColor {
        switch self {
        case .primary:
            return UIColor.label
        case .secondary:
            return UIColor.secondaryLabel
        case .accent:
            return UIColor.systemBlue
        case .error:
            return UIColor.systemRed
        }
    }
}
