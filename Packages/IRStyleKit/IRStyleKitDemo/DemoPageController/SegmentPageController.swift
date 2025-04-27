//
//  SegmentPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 27.04.2025.
//

import UIKit
import IRFoundation
import IRStyleKit

final class SegmentPageController: IRViewController,
                                   ShowcaseListViewControllerProtocol,
                                   SegmentViewDelegate {

    private lazy var segment = SegmentView(items: ["First", "Second", "Third"])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(segment)
        segment.translatesAutoresizingMaskIntoConstraints = false   // 🔑
        segment.delegate = self

        NSLayoutConstraint.activate([
            segment.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segment.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func segmentView(_ segmentView: SegmentView, didSelect index: Int) {
        print("Selected segment at index:", index)
    }
}
