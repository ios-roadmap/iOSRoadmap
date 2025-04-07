//
//  IRSwipeAction.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 7.04.2025.
//

import UIKit

public struct IRSwipeAction {
    public enum Style {
        case normal
        case destructive
    }

    public let title: String
    public let style: Style
    public let backgroundColor: UIColor?
    public let image: UIImage?
    public let handler: () -> Void

    public init(
        title: String,
        style: Style = .normal,
        backgroundColor: UIColor? = nil,
        image: UIImage? = nil,
        handler: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.backgroundColor = backgroundColor
        self.image = image
        self.handler = handler
    }

    func toContextualAction() -> UIContextualAction {
        let contextualStyle: UIContextualAction.Style = (style == .destructive) ? .destructive : .normal
        let action = UIContextualAction(style: contextualStyle, title: title) { _, _, completion in
            self.handler()
            completion(true)
        }
        action.backgroundColor = backgroundColor
        action.image = image
        return action
    }
}
