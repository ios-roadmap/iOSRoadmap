//
//  TableSwipeAction.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 7.04.2025.
//

import UIKit

// MARK: – Swipe Action Helper
@MainActor
public struct TableSwipeAction {
    public enum Style { case normal, destructive }

    public let title : String
    public let style : Style
    public let colour: UIColor?
    public let image : UIImage?
    public let handler: () -> Void

    public init(title: String,
                style: Style = .normal,
                colour: UIColor? = nil,
                image: UIImage? = nil,
                handler: @escaping () -> Void) {
        self.title   = title
        self.style   = style
        self.colour  = colour
        self.image   = image
        self.handler = handler
    }

    func toContextualAction() -> UIContextualAction {
        let ctxStyle: UIContextualAction.Style = (style == .destructive) ? .destructive : .normal
        let action  = UIContextualAction(style: ctxStyle, title: title) { _, _, done in
            self.handler(); done(true)
        }
        action.backgroundColor = colour
        action.image           = image
        return action
    }
}
