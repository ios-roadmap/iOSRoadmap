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
        // ––––– Filled –––––
        add(.filled, title: "Filled")
        add(.filled, title: "Filled + Icon", icon: UIImage(systemName: "bolt.fill"))
        addSpacer()

        // ––––– Outlined –––––
        add(.outlined, title: "Outlined")
        add(.outlined, title: "Outlined + Icon", icon: UIImage(systemName: "heart"))
        addSpacer()

        // ––––– Ghost –––––
        add(.ghost, title: "Ghost")
        add(.ghost, title: "Ghost + Icon", icon: UIImage(systemName: "hand.point.right.fill"))
        addSpacer()

        // ––––– Link (trailing icon) –––––
        add(.link, title: "Link")
        add(.link, title: "Link + Icon", icon: UIImage(systemName: "arrow.right"))
        addSpacer()

        // ––––– Icon-only (square) –––––
        add(.icon, icon: UIImage(systemName: "star.fill"))
        addSpacer()

        // ––––– Pure text –––––
        add(.onlyText, title: "Only Text")
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
