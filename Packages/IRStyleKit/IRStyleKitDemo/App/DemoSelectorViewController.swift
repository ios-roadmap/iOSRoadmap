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

    private lazy var uikitButton = Button(style: .outlinedPrimary, title: "UIKit") { [weak self] in
        self?.showUIKitDemo()
    }
    
    private lazy var swiftUIButton = Button(style: .outlinedPrimary, title: "SwiftUI") { [weak self] in
        self?.showSwiftUIDemo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Choose Demo Platform"
    }

    override func setup() {
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
