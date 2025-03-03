//
//  IRMaskView.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 1.03.2025.
//

import UIKit

public extension UITextField {
    func setCursorPosition(offset: Int) {
        guard let pos = position(from: beginningOfDocument, offset: offset) else { return }
        selectedTextRange = textRange(from: pos, to: pos)
    }
}

