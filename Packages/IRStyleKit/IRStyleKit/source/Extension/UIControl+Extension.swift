//
//  UIControl+Extension.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 13.04.2025.
//

import UIKit

public extension UIControl {
    
    @discardableResult
    func addAction(for event: UIControl.Event = .touchUpInside, action: @escaping () -> Void) -> Any {
        let uiAction = UIAction { _ in action() }
        addAction(uiAction, for: event)
        return uiAction
    }
}
