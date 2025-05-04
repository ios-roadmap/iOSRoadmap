//
//  Palette.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import UIKit

//TODO: Move to Assets Folder

enum Palette {

    // MARK: – Neutrals
    static let clear   = UIColor.clear
    static let white   = UIColor(hex: "#FFFFFF")
    static let black   = UIColor(hex: "#000000")

    static let black88 = UIColor(hex: "#2C2C2E")   // 88 %
    static let black82 = UIColor(hex: "#333333")   // 82 %
    static let black78 = UIColor(hex: "#3A3A3C")   // 78 %
    static let black59 = UIColor(hex: "#595959")   // 59 %
    static let black32 = UIColor(hex: "#A8A8A8")   // 32 %
    static let black15 = UIColor(hex: "#D9D9D9")   // 15 %
    static let black8  = UIColor(hex: "#F0F0F0")   //  8 %

    // MARK: – Brand accents
    static let blue = UIColor(hex: "#007AFF")      // Primary accent
    static let teal = UIColor(hex: "#008080")      // Secondary accent

    // MARK: – Feedback
    static let green = UIColor(hex: "#34C759")     // Success
    static let yellow = UIColor(hex: "#FFCC00")    // Warning
    static let red = UIColor(hex: "#FF3B30")       // Destructive

    // MARK: – Overlays
    /// 10 % black for light mode press‑overlay
    static let overlayLight = UIColor(white: 0.0, alpha: 0.10)
    /// 12 % white for dark mode press‑overlay
    static let overlayDark  = UIColor(white: 1.0, alpha: 0.12)
}
