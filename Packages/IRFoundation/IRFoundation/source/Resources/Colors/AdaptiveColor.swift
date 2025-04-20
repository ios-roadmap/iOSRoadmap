//
//  AdaptiveColor.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import UIKit

struct AdaptiveColor {
    let light: UIColor
    let dark: UIColor
    //TODO: ömer lightMode, darkMode
    
    var resolvedColor: UIColor {
        UIColor { trait in
            trait.userInterfaceStyle == .light ? light : dark
        }
    }
}
