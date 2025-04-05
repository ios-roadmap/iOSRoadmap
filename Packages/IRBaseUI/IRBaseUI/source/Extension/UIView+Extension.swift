//
//  UIView+Extension.swift
//  IRBaseUI
//
//  Created by Ömer Faruk Öztürk on 5.04.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
