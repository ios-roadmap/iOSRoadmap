//
//  SpacerView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import UIKit

//TODO: ömer stackview içerisinde boşluk doğru çalışmıyor.

public final class SpacerView: UIView {

    // MARK: – Axis
    public enum Axis { case vertical, horizontal }

    // MARK: – Stored state
    private var axis: Axis = .horizontal
    private var sizeConstraint: NSLayoutConstraint!

    // MARK: – Init
    public init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is unsupported") }

    // MARK: – Private
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        createSizeConstraint()
        updatePriorities()
    }

    private func createSizeConstraint() {
        sizeConstraint = makeSizeConstraint(for: axis)
        sizeConstraint.isActive = true
    }

    private func updatePriorities() {
        let layoutAxis: NSLayoutConstraint.Axis = (axis == .vertical) ? .vertical : .horizontal
        setContentHuggingPriority(.defaultLow, for: layoutAxis)
        setContentCompressionResistancePriority(.defaultLow, for: layoutAxis)

        // Opposite axis should resist any expansion
        let oppositeAxis: NSLayoutConstraint.Axis = (layoutAxis == .vertical) ? .horizontal : .vertical
        setContentHuggingPriority(.required, for: oppositeAxis)
        setContentCompressionResistancePriority(.required, for: oppositeAxis)
    }

    private func makeSizeConstraint(for axis: Axis) -> NSLayoutConstraint {
        switch axis {
        case .vertical:
            return heightAnchor.constraint(equalToConstant: 0)
        case .horizontal:
            return widthAnchor.constraint(equalToConstant: 0)
        }
    }
}

// MARK: - Public Builders
extension SpacerView {

    @discardableResult
    public func withAxis(_ kind: Axis) -> Self {
        guard axis != kind else { return self }

        sizeConstraint.isActive = false
        axis = kind
        sizeConstraint = makeSizeConstraint(for: kind)
        sizeConstraint.constant = 0
        sizeConstraint.isActive = true

        updatePriorities()
        return self
    }

    @discardableResult
    public func withSize(_ value: CGFloat) -> Self {
        sizeConstraint.constant = value
        return self
    }

    @discardableResult
    public func withBackground(_ colour: UIColor?) -> Self {
        backgroundColor = colour
        return self
    }
}
