//
//  TextLabelDemoPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import UIKit
import IRStyleKit
import IRFoundation

final class TextLabelDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func setup() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])

        addDemoSections()
    }

    private func addDemoSections() {
        addSection(title: "Text Transform") {
            TextTransform.allCases.map {
                createKeyValueView(
                    key: String(describing: $0),
                    value: "Omer Faruk Ozturk",
                    transform: $0
                )
            }
        }

        addSection(title: "Font Type") {
            FontType.allCases.map {
                createKeyValueView(
                    key: String(describing: $0),
                    value: "Font Type",
                    fontType: $0
                )
            }
        }

        addSection(title: "Font Size") {
            FontSize.allCases.map {
                createKeyValueView(
                    key: String(describing: $0),
                    value: "Font Size",
                    fontSize: $0
                )
            }
        }

        addSection(title: "Padding") {
            Spacing.allCases.map {
                createKeyValueView(
                    key: "\($0.rawValue)pt",
                    value: "Padding",
                    padding: $0
                )
            }
        }
    }

    private func addSection(title: String, content: () -> [UIView]) {
        let titleLabel = TextLabel()
            .withFont(.bold, size: .title1)
            .withText(title)
            .withAlignment(.left)

        stackView.addArrangedSubview(titleLabel)
        content().forEach { stackView.addArrangedSubview($0) }
    }

    private func createKeyValueView(
        key: String,
        value: String,
        transform: TextTransform? = nil,
        fontType: FontType? = nil,
        fontSize: FontSize? = nil,
        padding: Spacing? = nil
    ) -> UIStackView {
        let keyLabel = TextLabel()
            .withFont(.medium, size: .body)
            .withText(key)
            .withColor(.black)
            .withAlignment(.left)
            .withPadding(.small)

        let valueLabel = TextLabel()
            .withFont(fontType ?? .regular, size: fontSize ?? .body)
            .withText(value)
            .withColor(.gray)
            .withLines(1)
            .withAlignment(.left)
            .withPadding(padding ?? .small)
            .withDynamicType(false)

        if let transform = transform {
            valueLabel.withTransform(transform)
        }

        if padding != nil {
            valueLabel.layer.borderWidth = 1
            valueLabel.layer.borderColor = UIColor.systemGray4.cgColor
        }

        return KeyValueView(keyLabel: keyLabel, valueLabel: valueLabel)
    }
}
