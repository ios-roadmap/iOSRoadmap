//
//  AdaptiveColor.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import UIKit

struct AdaptiveColor {
    let lightMode: UIColor
    let darkMode: UIColor
    
    var resolvedColor: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .light ? lightMode : darkMode
        }
    }
}
