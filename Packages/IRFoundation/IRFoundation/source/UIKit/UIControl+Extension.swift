//
//  UIControl+Extension.swift
//  IRFoundation
//
//  Created by Ömer Faruk Öztürk on 29.04.2025.
//

import UIKit

public extension UIControl {
    /// Adds a closure-based action for a specific control event.
    @discardableResult
    func addAction(for event: UIControl.Event = .touchUpInside, action: @escaping () -> Void) -> Any {
        let uiAction = UIAction { _ in action() }
        addAction(uiAction, for: event)
        return uiAction
    }
}
