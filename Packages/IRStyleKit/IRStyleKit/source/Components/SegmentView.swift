//
//  SegmentView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 27.04.2025.
//

import UIKit
import IRFoundation

/// A horizontally‑scrolling segment control that utilises `Button` and `StackView`.
/// Selection is visualised by an independent `IndicatorView`.
public final class SegmentView: UIView {

    // MARK: - Public

    public struct Segment {
        public let title: String
        public init(title: String) { self.title = title }
    }

    public var onSelectionChanged: ((Int) -> Void)?

    public private(set) var selectedIndex: Int = 0 {
        didSet { updateSelection(animated: true) }
    }

    // MARK: - Private

    private let segments: [Segment]
    private var buttons: [Button] = []
    private var stackView: StackView!

    private let indicator = IndicatorView()
    private var indicatorLeading: NSLayoutConstraint!
    private var indicatorWidth: NSLayoutConstraint!

    // MARK: - Init

    public init(segments: [Segment]) {
        self.segments = segments
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }
    

    @available(*, unavailable)
    public required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    // MARK: - Setup

    private func setup() {
        // Build buttons
        buttons = segments.enumerated().map { index, segment in
            Button()
                .withStyle(.onlyText)
                .withTitle(segment.title)
                .withTag(index)
                .withAction { [weak self] in
                    guard let self else { return }
                    selectedIndex = index
                    onSelectionChanged?(selectedIndex)
                }
        }

        // Build stack view with all buttons
        stackView = StackView { buttons }
            .axis(.horizontal)
            .spacing(0)
            .distribution(.fillEqually)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])

        // Add indicator
        addSubview(indicator)
        indicatorLeading = indicator.leadingAnchor.constraint(equalTo: leadingAnchor)
        indicatorWidth   = indicator.widthAnchor.constraint(equalToConstant: 20)
        NSLayoutConstraint.activate([
            indicatorLeading,
            indicatorWidth,
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 3)
        ])

        // Force layout before calculating indicator frame
        layoutIfNeeded()

        // Initial selection (with accurate frame info)
        updateSelection(animated: false)
    }


    // MARK: - Selection handling

    private func updateSelection(animated: Bool) {
        buttons.enumerated().forEach { i, btn in
            let isSelected = i == selectedIndex
            //TODO: deneme olarak aldım tintColor builder'dan gelmeli.
            _ = btn.tintColor = isSelected ? .red : .orange
        }

        // Ensure layout is up‑to‑date before querying frames.
        layoutIfNeeded()

        let selectedButton = buttons[selectedIndex]
        let frameInSelf    = selectedButton.convert(selectedButton.bounds, to: self)
        indicatorLeading.constant = frameInSelf.minX
        indicatorWidth.constant   = frameInSelf.width

        guard animated else { return }
        UIView.animate(withDuration: 0.25) { self.layoutIfNeeded() }
    }
}
