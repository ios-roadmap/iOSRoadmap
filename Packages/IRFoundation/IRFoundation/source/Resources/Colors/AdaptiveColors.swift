//
//  AdaptiveColors.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import UIKit

enum Adaptive {

    enum Text {
        static let primary = AdaptiveColor(light: Palette.black82,
                                           dark:  Palette.white)
        static let secondary = AdaptiveColor(light: Palette.black59,
                                             dark:  Palette.black15)
    }

    enum BG {
        static let `default` = AdaptiveColor(light: Palette.black8,
                                             dark:  Palette.black82)
        static let elevated  = AdaptiveColor(light: Palette.black15, //DENEME
                                             dark:  Palette.black78)
    }

    enum Border {
        static let `default` = AdaptiveColor(light: Palette.black15,
                                             dark:  Palette.black32)
    }

    enum Accent {
        static let primary   = AdaptiveColor(light: Palette.blue,
                                             dark:  Palette.blue)
        static let secondary = AdaptiveColor(light: Palette.black59,
                                             dark:  Palette.white)
    }

    enum Feedback {
        static let success     = AdaptiveColor(light: Palette.green,
                                               dark:  Palette.green)
        static let warning     = AdaptiveColor(light: Palette.yellow,
                                               dark:  Palette.yellow)
        static let destructive = AdaptiveColor(light: Palette.red,
                                               dark:  Palette.red)
    }

    enum Overlay {
        static let pressed = AdaptiveColor(light: Palette.overlayLight,
                                           dark:  Palette.overlayDark)
    }
}
