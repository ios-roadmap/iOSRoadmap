//
//  WrappingFlowDemo.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 14.08.2025.
//  Updated: 18.08.2025 — UICollectionView kullanılmadan wrap/flow yerleşimi
//

import UIKit
import IRStyleKit

// MARK: - TagView
final class TagView: UIView {
    private let label = UILabel()

    init(text: String) {
        super.init(frame: .zero)
        backgroundColor = .systemGray6
        layer.cornerRadius = 8
        directionalLayoutMargins = .init(top: 6, leading: 10, bottom: 6, trailing: 10)

        label.text = text
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
        ])

        setContentCompressionResistancePriority(.required, for: .horizontal)
        setContentHuggingPriority(.required, for: .horizontal)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - WrappingFlowView (UICollectionView yok)
final class WrappingFlowView: UIView {

    var itemSpacing: CGFloat = 8 { didSet { setNeedsLayout(); invalidateIntrinsicContentSize() } }
    var lineSpacing: CGFloat = 8 { didSet { setNeedsLayout(); invalidateIntrinsicContentSize() } }
    var contentInsets: UIEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12) {
        didSet { setNeedsLayout(); invalidateIntrinsicContentSize() }
    }

    private let scrollView = UIScrollView()
    private var itemViews: [UIView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); setup() }

    private func setup() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.showsHorizontalScrollIndicator = false
    }

    func setItems(_ views: [UIView]) {
        for v in itemViews { v.removeFromSuperview() }
        itemViews = views
        for v in itemViews { scrollView.addSubview(v) }
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }

    func setItems(_ strings: [String], makeView: (String) -> UIView = { TagView(text: $0) }) {
        setItems(strings.map(makeView))
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let availableWidth = bounds.width
        guard availableWidth > 0 else { return }

        let maxLineWidth = availableWidth - contentInsets.left - contentInsets.right

        var x = contentInsets.left
        var y = contentInsets.top
        var lineHeight: CGFloat = 0

        for v in itemViews {
            let targetSize = CGSize(width: maxLineWidth, height: .greatestFiniteMagnitude)
            let fitting = v.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .defaultLow,
                verticalFittingPriority: .fittingSizeLevel
            )
            let w = min(fitting.width, maxLineWidth)
            let h = fitting.height

            if x > contentInsets.left && (x + w) > (availableWidth - contentInsets.right) {
                x = contentInsets.left
                y += lineHeight + lineSpacing
                lineHeight = 0
            }

            v.frame = CGRect(x: x, y: y, width: w, height: h)
            x += w + itemSpacing
            lineHeight = max(lineHeight, h)
        }

        let contentHeight = (itemViews.isEmpty ? 0 : (y + lineHeight)) + contentInsets.bottom
        scrollView.contentSize = CGSize(width: availableWidth, height: max(contentHeight, bounds.height))
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        let height = scrollView.contentSize.height > 0 ? scrollView.contentSize.height : UIView.noIntrinsicMetric
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        invalidateIntrinsicContentSize()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setNeedsLayout()
        invalidateIntrinsicContentSize()
    }
}

// MARK: - Demo VC
final class HStackDemoViewController: IRViewController, ShowcaseListViewControllerProtocol {

    private let items = [
        "UIKit","Auto Layout","Self-Sizing","Flow’suz Wrap",
        "LongText-Örnek-1234567890","Tag","iOS","Swift","CustomView","Wrap","Satır Kırma"
    ]

    private let wrappingView = WrappingFlowView()

    override func loadView() {
        view = wrappingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Wrapping (No CollectionView)"
        wrappingView.backgroundColor = .systemBackground
        wrappingView.itemSpacing = 8
        wrappingView.lineSpacing = 8
        wrappingView.contentInsets = .init(top: 12, left: 12, bottom: 12, right: 12)
        wrappingView.setItems(items) { TagView(text: $0) }
    }
}
