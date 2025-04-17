//
//  AdaptiveColors.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import Foundation

enum AdaptiveColors {
    
    enum TextAdaptiveColors {
        static let primary = AdaptiveColor(
            lightMode: Palette.black82,
            darkMode: Palette.white
        )
        
        static let secondary = AdaptiveColor(
            lightMode: Palette.black59,
            darkMode: Palette.black15
        )
    }
    
    enum BackgroundAdaptiveColors {
        static let `default` = AdaptiveColor(
            lightMode: Palette.black8,
            darkMode: Palette.black82
        )
        
        static let elevated = AdaptiveColor(
            lightMode: Palette.white,
            darkMode: Palette.black78
        )
    }

    enum BorderAdaptiveColors {
        static let `default` = AdaptiveColor(
            lightMode: Palette.black15,
            darkMode: Palette.black32
        )
    }
}
