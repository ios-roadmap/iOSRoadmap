//
//  DemoSelectorViewController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 27.04.2025.
//

import UIKit
import SwiftUI
import IRStyleKit

final class DemoSelectorViewController: IRViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose Demo Platform"
    }

    override func setup() {
        let uikitButton = Button()
            .withStyle(.outlinedPrimary)
            .withTitle("UIKit")
            .withAction { [weak self] in
                self?.showUIKitDemo()
            }
        
        let swiftUIButton = Button()
            .withStyle(.outlinedPrimary)
            .withTitle("SwiftUI")
            .withAction { [weak self] in
                self?.showSwiftUIDemo()
            }
        
        
        let stackView = StackView(.vertical(spacing: 24)) {
            uikitButton
            swiftUIButton
        }

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: – Navigation

    private func showUIKitDemo() {
        let vc = ShowcaseListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showSwiftUIDemo() {
        let swiftUIView = ShowcaseListView()
        let host = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(host, animated: true)
    }
}
