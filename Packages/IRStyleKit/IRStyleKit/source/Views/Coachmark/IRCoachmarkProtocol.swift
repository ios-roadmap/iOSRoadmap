//
//  IRCoachmarkProtocol.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 11.04.2025.
//

import UIKit

public protocol IRCoachmarkProtocol {
    var key: String { get }
    var ownerView: UIView { get }
    var title: String { get }
    var message: String { get }
    var snapshotMargin: UIEdgeInsets { get }
    var direction: IRCoachmarkDirection { get }
}

public enum IRCoachmarkDirection {
    case top
    case bottom
    //    case left
    //    case right
}

public struct IRCoachmarkPageData {
    let title: String
    let description: String
    let numberOfPages: Int
    let pageIndex: Int
    let triangleViewMidX: CGFloat
    let direction: IRCoachmarkDirection
    let actionButtonTitle: String
    
    public init(
        title: String,
        description: String,
        numberOfPages: Int = 1,
        pageIndex: Int,
        triangleViewMidX: CGFloat,
        direction: IRCoachmarkDirection,
        actionButtonTitle: String) {
            self.title = title
            self.description = description
            self.numberOfPages = numberOfPages
            self.pageIndex = pageIndex
            self.triangleViewMidX = triangleViewMidX
            self.direction = direction
            self.actionButtonTitle = actionButtonTitle
        }
}
