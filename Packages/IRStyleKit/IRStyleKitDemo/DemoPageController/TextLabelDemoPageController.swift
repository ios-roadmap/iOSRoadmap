//
//  TextLabelDemoPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 6.04.2025.
//

import UIKit
import IRStyleKit
import IRFoundation

//TODO: Daha mantıklı gösterim olmalı. Sadece Demo'nun Demo'su oldu burası.

final class TextLabelDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {

    // MARK: - Views --------------------------------------------------------

    private lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.axis         = .vertical
        v.alignment     = .fill
        v.distribution  = .fill
        v.spacing       = 8
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    // MARK: - Lifecycle ----------------------------------------------------

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

    // MARK: - Demo content --------------------------------------------------

    private func addDemoSections() {

        addSection(title: "Text Transform") {
            TextTransform.allCases.map {
                createKeyValueView(
                    key: String(describing: $0),
                    value: "Omer Faruk Ozturk",
                    transform: $0,
                    typography: .body(.regular)
                )
            }
        }

        addSection(title: "Typography") {
            allTypographyCases().map {
                createKeyValueView(
                    key: String(describing: $0),
                    value: "Omer Faruk Ozturk",
                    typography: $0
                )
            }
        }

        addSection(title: "Padding") {
            Spacing.allCases.map {
                createKeyValueView(
                    key: "\($0.rawValue) pt",
                    value: "Padding",
                    typography: .control(.button),
                    padding: $0
                )
            }
        }
    }

    // MARK: - Helpers -------------------------------------------------------

    private func addSection(title: String, content: () -> [UIView]) {
        let titleLabel = TextLabel()
            .withTypography(.body(.semibold))
            .withText(title)
            .withAlignment(.left)

        stackView.addArrangedSubview(titleLabel)
        content().forEach { stackView.addArrangedSubview($0) }
    }

    private func createKeyValueView(
        key: String,
        value: String,
        transform: TextTransform? = nil,
        typography: Typography,
        padding: Spacing? = nil
    ) -> UIStackView {

        let keyLabel = TextLabel()
            .withTypography(.control(.button))
            .withText(key)
            .withTextColor(.black)
            .withAlignment(.left)
            .withPadding(.small)

        let valueLabel = TextLabel()
            .withTypography(typography)
            .withText(value)
            .withTextColor(.gray)
            .withLines(1)
            .withAlignment(.left)
            .withPadding(padding ?? .small)

        if let transform = transform { valueLabel.withTransform(transform) }

        if padding != nil {
            valueLabel.layer.borderWidth  = 1
            valueLabel.layer.borderColor  = UIColor.systemGray4.cgColor
        }
        
        return StackView {
            keyLabel
            SpacerView()
            valueLabel
        }
        .axis(.horizontal)
        .spacing(0) // or customise if needed

    }

    /// Flattens every `Typography` variant into an array for demo purposes.
    private func allTypographyCases() -> [Typography] {
        var list: [Typography] = [
            .largeTitle,
            .headline,
            .subheadline,
            .callout,
            .footnote,
            .monospacedDigit
        ]

        list += Typography.Display.allCases.map { .display($0) }
        list += Typography.Title.allCases.map   { .title($0)   }
        list += Typography.Body.allCases.map    { .body($0)    }
        list += Typography.Caption.allCases.map { .caption($0) }
        list += Typography.Control.allCases.map { .control($0) }
        list += Typography.Badge.allCases.map   { .badge($0)   }

        return list
    }
}
