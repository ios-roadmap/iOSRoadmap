//
//  IRViewsTableSectionItem.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 13.03.2025.
//

import UIKit

@MainActor
public enum IRViewsTableSectionItem {
    case imageButtonViews([IRViewsImageButtonViewModel])
    case spacer(CGFloat)
    
    func toItem() -> IRViewsBaseTableItemProtocol {
        switch self {
        case .imageButtonViews(let items):
            return IRViewsBaseTableItem(viewModel: IRViewsImageButtonViewsCellViewModel(items: items))
        case .spacer(let height):
            return IRViewsBaseTableItem(viewModel: IRViewsSpacerCellViewModel(height: height))
        }
    }
}
