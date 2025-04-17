//
//  UIColor.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitised = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitised.hasPrefix("#") {
            hexSanitised.removeFirst()
        }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitised).scanHexInt64(&rgb)

        let r, g, b, a: CGFloat
        switch hexSanitised.count {
        case 6:
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255
            b = CGFloat(rgb & 0x0000FF) / 255
            a = 1.0

        case 8:
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255
            a = CGFloat(rgb & 0x000000FF) / 255

        default:
            r = 0; g = 0; b = 0; a = 1
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
