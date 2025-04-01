//
//  UIView+Extension.swift
//  IRBase
//
//  Created by Ömer Faruk Öztürk on 26.03.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
