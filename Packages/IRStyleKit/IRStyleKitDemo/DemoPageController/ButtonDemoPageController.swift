//
//  ButtonDemoPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 17.04.2025.
//

import UIKit
import IRStyleKit
import IRFoundation

final class ButtonDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {
    
    private let stack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        populateButtons()
    }
    
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        
        stack.axis         = .vertical
        stack.spacing      = 12
        stack.alignment    = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    private func populateButtons() {
        // Filled ----------------------------------------------------------------
        add(.filledPrimary,     title: "Primary")
        add(.filledSecondary,   title: "Secondary")
        add(.filledSuccess,     title: "Success")
        add(.filledWarning,     title: "Warning ⚠︎")
        add(.filledDestructive, title: "Delete", icon: .init(systemName: "trash"))

        addSpacer()

        // Outlined --------------------------------------------------------------
        add(.outlinedPrimary,     title: "Outlined Primary")
        add(.outlinedSecondary,   title: "Outlined Secondary")
        add(.outlinedDestructive, title: "Outlined Delete", icon: .init(systemName: "trash"))

        addSpacer()

        // Ghost -----------------------------------------------------------------
        add(.ghost, title: "Ghost")

        addSpacer()

        // Link ------------------------------------------------------------------
        add(.link,           title: "Plain Link")
        add(.linkUnderlined, title: "Underlined Link", icon: .init(systemName: "arrow.up.right"))

        addSpacer()

        // Icon‑only -------------------------------------------------------------
        add(.iconOnly, icon: .init(systemName: "star.fill"))
    }

    private func add(
        _ style: ButtonStyle,
        title: String? = nil,
        icon: UIImage? = nil
    ) {
        let button = Button()
            .withStyle(style)
            .withTitle(title)
            .withIcon(icon)
            .withAction {
                print("\(style) tapped")
            }

        stack.addArrangedSubview(button)
    }

    
    private func addSpacer() {
        let spacer = UIView()
        spacer.heightAnchor.constraint(equalToConstant: 8).isActive = true
        stack.addArrangedSubview(spacer)
    }
}
