//
//  ButtonDemoPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import UIKit
import IRStyleKit

final class ButtonDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let scroll = UIScrollView()
        let stack = UIStackView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill

        view.addSubview(scroll)
        scroll.addSubview(stack)

        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scroll.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            stack.topAnchor.constraint(equalTo: scroll.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            stack.widthAnchor.constraint(equalTo: scroll.widthAnchor)
        ])

        stack.addArrangedSubview(Button(style: .primaryLargeFilled)
            .withTitle("Primary Filled")
            .withAction { print("Primary Large Filled tapped") })

        stack.addArrangedSubview(Button(style: .primarySmallOutline)
            .withTitle("Primary Outline")
            .withAction { print("Primary Small Outline tapped") })

        stack.addArrangedSubview(Button(style: .secondaryLargeTextOnly)
            .withTitle("Secondary Text Only")
            .withAction { print("Secondary Text tapped") })

        stack.addArrangedSubview(Button(style: .secondarySmallFilled)
            .withTitle("Secondary Filled")
            .withAction { print("Secondary Small Filled tapped") })

        stack.addArrangedSubview(Button(style: .destructiveLargeFilled)
            .withTitle("Delete")
            .withIcon(UIImage(systemName: "trash"))
            .withAction { print("Destructive tapped") })

        stack.addArrangedSubview(Button(style: .destructiveSmallTextOnly)
            .withTitle("Remove")
            .withAction { print("Remove tapped") })

        stack.addArrangedSubview(Button(style: .iconLeadingSmall)
            .withIcon(UIImage(systemName: "plus"))
            .withAction { print("Icon only tapped") })

        stack.addArrangedSubview(Button(style: .iconTrailingLarge)
            .withTitle("Next")
            .withIcon(UIImage(systemName: "chevron.right"))
            .withAction { print("Next tapped") })
    }
}
