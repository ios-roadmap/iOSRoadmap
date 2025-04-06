//
//  IRTableViewSectionBuilder.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 31.03.2025.
//

import IRBaseUI

@MainActor
public class IRTableViewSectionBuilder {
    private var headerTitle: String?
    private var items: [IRTableViewItemProtocol] = []

    public init(_ headerTitle: String? = nil) {
        self.headerTitle = headerTitle
    }
    
    public func add(_ item: IRTableViewCellItem) -> Self {
        items.append(item.toItem())
        return self
    }
    
    public func build() -> IRTableViewSection {
        IRTableViewSection(headerTitle: headerTitle, items: items)
    }
}
