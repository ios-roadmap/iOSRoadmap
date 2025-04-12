//
//  CoachmarkDemoPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 11.04.2025.
//

import UIKit
import IRStyleKit

final class CoachmarkDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {

    private let coachmarkManager = IRCoachmarkManager()

    private let topBox = UIView()
    private let bottomBox = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        drawBoxes()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layoutIfNeeded()
        showCoachmarks(for: [topBox, bottomBox])
    }

    private func drawBoxes() {
        let boxSize: CGFloat = 100

        topBox.backgroundColor = .systemBlue
        topBox.translatesAutoresizingMaskIntoConstraints = false
        topBox.heightAnchor.constraint(equalToConstant: boxSize).isActive = true
        topBox.widthAnchor.constraint(equalToConstant: boxSize).isActive = true

        bottomBox.backgroundColor = .systemRed
        bottomBox.translatesAutoresizingMaskIntoConstraints = false
        bottomBox.heightAnchor.constraint(equalToConstant: boxSize).isActive = true
        bottomBox.widthAnchor.constraint(equalToConstant: boxSize).isActive = true

        let stackView = UIStackView(arrangedSubviews: [topBox, bottomBox])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func showCoachmarks(for boxes: [UIView]) {
        let coachmarks: [IRCoachmarkProtocol] = [
            DemoCoachmark(
                key: "topBoxCoachmark",
                ownerView: boxes[0],
                title: "Üst Kutu",
                message: "Bu üst kutudur. Önemli bilgileri gösterir.",
                snapshotMargin: .init(top: 4, left: 4, bottom: 4, right: 4),
                direction: .bottom
            ),
            DemoCoachmark(
                key: "bottomBoxCoachmark",
                ownerView: boxes[1],
                title: "Alt Kutu",
                message: "Bu alt kutudur. Detaylara buradan erişebilirsin.",
                snapshotMargin: .init(top: 4, left: 4, bottom: 4, right: 4),
                direction: .top
            )
        ]

        coachmarkManager.delegate = self
        coachmarkManager.setup(coachmarks: coachmarks, parentView: view)
    }
}

extension CoachmarkDemoPageController: IRCoachmarkManagerDelegate {
    func coachmarkDidComplete() {
        print("✅ Coachmark tamamlandı.")
    }

    func coachmarkDidCurrentPage(index: Int, coachmark: IRCoachmarkProtocol) {
        print("▶️ Şu anki coachmark: \(index), key: \(coachmark.key)")
    }
}

struct DemoCoachmark: IRCoachmarkProtocol {
    let key: String
    let ownerView: UIView
    let title: String
    let message: String
    let snapshotMargin: UIEdgeInsets
    let direction: IRCoachmarkDirection
}
