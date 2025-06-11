//
//  IRCoachmark.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 13.04.2025.
//

import UIKit

@MainActor
public protocol IRCoachmarkProtocol {
    var key: String { get }
    var ownerView: UIView { get }
    var title: String { get }
    var message: String { get }
    var snapshotMargin: UIEdgeInsets { get }
    var snapshotCrop: UIEdgeInsets { get }
    var direction: IRCoachmarkDirection { get }
}

@MainActor
public extension IRCoachmarkProtocol {

    // MARK: – Private Helper
    private func makeFlag() -> InsecurePersistent<Bool> {
        InsecurePersistent(
            key: .init(
                id: "Coachmark_\(key)",
                defaultValue: false,
                suitName: "omerfarukozturk.com"
            )
        )
    }

    // MARK: – Public API
    var hasBeenShown: Bool {
        makeFlag().wrappedValue ?? false
        return false
    }

    func markAsShown() {
        var flag = makeFlag()
        flag.wrappedValue = true
    }

    func addSnapshot(to parentView: UIView) -> UIView? {
        parentView.addSnapshot(of: ownerView,
                               margin: snapshotMargin,
                               crop: snapshotCrop)
    }
}

public struct IRCoachmark: IRCoachmarkProtocol {
    public let key: String
    public let ownerView: UIView
    public let title: String
    public let message: String
    public let snapshotMargin: UIEdgeInsets
    public let snapshotCrop: UIEdgeInsets
    public let direction: IRCoachmarkDirection
    
    public init(key: String, ownerView: UIView, title: String, message: String, snapshotMargin: UIEdgeInsets = .zero, snapshotCrop: UIEdgeInsets = .zero, direction: IRCoachmarkDirection) {
        self.key = key
        self.ownerView = ownerView
        self.title = title
        self.message = message
        self.snapshotMargin = snapshotMargin
        self.snapshotCrop = snapshotCrop
        self.direction = direction
    }
}

public enum IRCoachmarkDirection {
    case top, bottom
}
