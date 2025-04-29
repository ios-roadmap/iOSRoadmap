//
//  TableSection.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 7.04.2025.
//

import UIKit

// MARK: – Header / Footer Model
public enum TableHeaderFooter: Equatable {
    case none
    case title(String)
    case view(UIView)
}

// MARK: – Section Model
public struct TableSection: Equatable {
    public let id   : String
    public var header: TableHeaderFooter
    public var footer: TableHeaderFooter
    public var items : [CellViewModelProtocol]

    public init(id: String = UUID().uuidString,
                header: TableHeaderFooter = .none,
                footer: TableHeaderFooter = .none,
                items : [CellViewModelProtocol]) {
        self.id     = id
        self.header = header
        self.footer = footer
        self.items  = items
    }
    
    public static func == (lhs: TableSection, rhs: TableSection) -> Bool {
        lhs.id == rhs.id &&
        lhs.header == rhs.header &&
        lhs.footer == rhs.footer &&
        lhs.items.count == rhs.items.count
    }
}
