//
//  SegmentPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 27.04.2025.
//

import UIKit
import IRFoundation
import IRStyleKit

final class SegmentDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {

    private let segmentView = SegmentView(segments: [
        .init(title: "Overview"),
        .init(title: "Stats"),
        .init(title: "Settings")
    ])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutSegmentView()
        segmentView.onSelectionChanged = { index in
            print("Selected segment: \(index)")
        }
    }

    private func layoutSegmentView() {
        view.addSubview(segmentView)
        NSLayoutConstraint.activate([
            segmentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
