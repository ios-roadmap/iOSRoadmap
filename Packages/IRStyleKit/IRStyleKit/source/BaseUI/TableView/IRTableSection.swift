//
//  IRTableSection.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 7.04.2025.
//

import UIKit

public enum IRTableHeaderFooter {
    case none
    case title(String)
    case view(UIView)
}

public struct IRTableSection {
    public let id: String
    public var header: IRTableHeaderFooter
    public var footer: IRTableHeaderFooter
    public var items: [IRCellViewModelProtocol]
    
    public init(id: String = UUID().uuidString,
                header: IRTableHeaderFooter = .none,
                footer: IRTableHeaderFooter = .none,
                items: [IRCellViewModelProtocol]) {
        self.id = id
        self.header = header
        self.footer = footer
        self.items = items
    }
}
