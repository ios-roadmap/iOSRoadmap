//
//  CoachmarkDemoPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 11.04.2025.
//

import UIKit
import IRStyleKit

final class CoachmarkDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {

    // MARK: - Properties

    private let coachmarkManager = IRCoachmarkManager()

    private let topBox: UIView = {
        let box = UIView()
        box.backgroundColor = .systemBlue
        box.translatesAutoresizingMaskIntoConstraints = false
        box.heightAnchor.constraint(equalToConstant: 100).isActive = true
        box.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return box
    }()

    private let bottomBox: UIView = {
        let box = UIView()
        box.backgroundColor = .systemRed
        box.translatesAutoresizingMaskIntoConstraints = false
        box.heightAnchor.constraint(equalToConstant: 100).isActive = true
        box.widthAnchor.constraint(equalToConstant: 100).isActive = true
        return box
    }()
    
    private let fullWidthBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = .systemOrange
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    // MARK: - Lifecycle


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layoutIfNeeded()
        showCoachmarks()
    }
    
    override func setup() {
        setupLayout()
    }

    // MARK: - Layout Setup

    private func setupLayout() {
        view.addSubview(topBox)
        view.addSubview(bottomBox)

        NSLayoutConstraint.activate([
            topBox.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            topBox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            bottomBox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            bottomBox.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        view.addSubview(fullWidthBar)

        NSLayoutConstraint.activate([
            fullWidthBar.topAnchor.constraint(equalTo: topBox.bottomAnchor, constant: 60),
            fullWidthBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullWidthBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            fullWidthBar.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    // MARK: - Coachmark Display

    private func showCoachmarks() {
        let coachmarks: [IRCoachmarkProtocol] = [
            IRCoachmark(
                key: "topBoxCoachmark",
                ownerView: topBox,
                title: "Upper Box",
                message: "This is the upper box – it displays key information.",
                snapshotMargin: UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
                direction: .top
            ),
            IRCoachmark(
                key: "bottomBoxCoachmark",
                ownerView: bottomBox,
                title: "Lower Box",
                message: "This is the lower box – tap here for more details.",
                snapshotMargin: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40),
                direction: .bottom
            ),
            IRCoachmark(
                key: "fullWidthBar",
                ownerView: fullWidthBar,
                title: "fullWidthBar",
                message: "fullWidthBar fullWidthBar fullWidthBar fullWidthBar",
                snapshotCrop: .init(top: -25, left: -20, bottom: -25, right: -30),
                direction: .top
            ),
        ]

        coachmarkManager.delegate = self
        coachmarkManager.setupCoachmarks(coachmarks, on: view)
    }
}

// MARK: - IRCoachmarkManagerDelegate Conformance

extension CoachmarkDemoPageController: IRCoachmarkManagerDelegate {
    func coachmarksDidComplete() {
        print("✅ Coachmark completed.")
    }

    func coachmarkDidCurrentPage(index: Int, coachmark: IRCoachmarkProtocol) {
        print("▶️ Current coachmark index: \(index), key: \(coachmark.key)")
    }
}
