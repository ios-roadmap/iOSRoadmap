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
    var direction: IRCoachmarkDirection { get }
}

@MainActor
public extension IRCoachmarkProtocol {
    var hasBeenShown: Bool {
        //TODO: ömer IRDefaults enum'ı eklenecek UserDefaults kullanımları için.
//        UserDefaults.standard.bool(forKey: "\(CoachmarkManager.Constants.baseKey)\(key)")
        return false
    }
    
    func markAsShown() {
//        UserDefaults.standard.set(true, forKey: "\(CoachmarkManager.Constants.baseKey)\(key)")
    }
    
    func addSnapshot(to parentView: UIView) -> UIView? {
        parentView.addSnapshot(of: ownerView, with: snapshotMargin)
    }
}

public struct IRCoachmark: IRCoachmarkProtocol {
    public let key: String
    public let ownerView: UIView
    public let title: String
    public let message: String
    public let snapshotMargin: UIEdgeInsets
    public let direction: IRCoachmarkDirection
    
    public init(key: String, ownerView: UIView, title: String, message: String, snapshotMargin: UIEdgeInsets, direction: IRCoachmarkDirection) {
        self.key = key
        self.ownerView = ownerView
        self.title = title
        self.message = message
        self.snapshotMargin = snapshotMargin
        self.direction = direction
    }
}

public enum IRCoachmarkDirection {
    case top, bottom
}
