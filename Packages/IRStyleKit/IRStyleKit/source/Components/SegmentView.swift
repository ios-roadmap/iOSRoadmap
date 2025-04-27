//
//  SegmentView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 27.04.2025.
//

import UIKit
import IRFoundation

public protocol SegmentViewDelegate: AnyObject {
    func segmentView(_ segmentView: SegmentView, didSelect index: Int)
}

// MARK: – SegmentView
public final class SegmentView: UIView {

    // MARK: Public surface
    public weak var delegate: SegmentViewDelegate?
    public private(set) var selectedIndex: Int = 0 {
        didSet { guard oldValue != selectedIndex else { return }
                 applyAppearance()
                 delegate?.segmentView(self, didSelect: selectedIndex) }
    }

    // MARK: Private state
    private let items: [String]
    // MARK: UI
    private lazy var buttons: [Button] = items.enumerated().map { idx, title in
        Button()
            .withTitle(title)
            .withTag(idx)
            .withStyle(.outlinedPrimary)
            .withAction { [weak self] in self?.select(at: idx) }
    }

    private lazy var stackView: StackView = {
        StackView(.horizontal()) { buttons }   // <- arranges every Button
    }()

    // MARK: Init
    public init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
        configure()
        applyAppearance()
    }

    @available(*, unavailable) public required init?(coder: NSCoder) {
        fatalError("Use init(items:) instead.")
    }

    // MARK: Layout
    private func configure() {
        addSubview(stackView)
        stackView.pinEdges(to: self)
        select(at: 0)
    }

    // MARK: Styling
    private func applyAppearance() {
        buttons.enumerated().forEach { idx, button in
            button.withStyle(idx == selectedIndex ? .filledPrimary : .outlinedPrimary)
        }
    }

    // MARK: Public API
    public func select(at index: Int) {
        guard (0..<buttons.count).contains(index), index != selectedIndex else { return }
        selectedIndex = index
    }
}
