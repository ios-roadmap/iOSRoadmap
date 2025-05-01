//
//  StackView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 23.04.2025.
//

import UIKit

//TODO: Burası Düzenlenecek
@resultBuilder
public enum ArrangedSubviewsBuilder {
    public static func buildBlock(_ components: UIView...) -> [UIView] { components }
    public static func buildBlock(_ components: [UIView]...) -> [UIView] { components.flatMap { $0 } }
    public static func buildExpression(_ expr: UIView) -> [UIView] { [expr] }
    public static func buildExpression<C: Collection>(_ expr: C) -> [UIView] where C.Element: UIView { Array(expr) }
    public static func buildArray(_ parts: [[UIView]]) -> [UIView] { parts.flatMap { $0 } }

    // Catch throwing expressions and ignore them gracefully (optional but useful)
    public static func buildEither(first component: [UIView]) -> [UIView] { component }
    public static func buildEither(second component: [UIView]) -> [UIView] { component }
    public static func buildOptional(_ component: [UIView]?) -> [UIView] { component ?? [] }
    public static func buildLimitedAvailability(_ component: [UIView]) -> [UIView] { component }
}

public final class StackView: UIStackView {

    // MARK: Init – takes only the arranged subviews
    public init(@ArrangedSubviewsBuilder _ views: () -> [UIView]) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        views().forEach { self.addArrangedSubview($0) }
    }

    @available(*, unavailable)
    public required init(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    // MARK: Chainable configuration
    @discardableResult public func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }

    @discardableResult public func spacing(_ value: CGFloat) -> Self {
        self.spacing = value
        return self
    }

    @discardableResult public func distribution(_ value: UIStackView.Distribution) -> Self {
        self.distribution = value
        return self
    }

    @discardableResult public func alignment(_ value: UIStackView.Alignment) -> Self {
        self.alignment = value
        return self
    }
}
