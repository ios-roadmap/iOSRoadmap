//
//  StackView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 23.04.2025.
//

import UIKit

@resultBuilder
public enum ArrangedSubviewsBuilder {

    public static func buildBlock(_ components: UIView...) -> [UIView] { components }

    /// Accept any number of `[UIView]` collections.
    public static func buildBlock(_ components: [UIView]...) -> [UIView] {
        components.flatMap { $0 }
    }

    public static func buildExpression(_ expr: UIView) -> [UIView] { [expr] }

    public static func buildExpression<C: Collection>(_ expr: C) -> [UIView]
    where C.Element: UIView {
        Array(expr)
    }

    public static func buildArray(_ parts: [[UIView]]) -> [UIView] { parts.flatMap { $0 } }
}

public final class StackView: UIStackView {
    
    public enum Kind {
        case horizontal(spacing: CGFloat = 8)
        case vertical(spacing: CGFloat = 4)
    }
    
    public init(
        _ kind: Kind, @ArrangedSubviewsBuilder _ views: () throws -> [UIView]
    ) rethrows {
        super.init(frame: .zero)
        switch kind {
        case .horizontal(let spacing):
            axis = .horizontal
            self.spacing = spacing
        case .vertical(let spacing):
            axis = .vertical
            self.spacing = spacing
        }
        translatesAutoresizingMaskIntoConstraints = false
        for view in try views() {
            addArrangedSubview(view)
        }
    } 
    
    public required init(coder: NSCoder) {
        fatalError("Use init(_:views:) instead.")
    }
}

public extension UIView {
    func pinEdges(to other: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: other.leadingAnchor),
            trailingAnchor.constraint(equalTo: other.trailingAnchor),
            topAnchor.constraint(equalTo: other.topAnchor),
            bottomAnchor.constraint(equalTo: other.bottomAnchor)
        ])
    }
}
