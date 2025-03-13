//
//  IRViewsTableSectionItem.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 13.03.2025.
//

import UIKit

@MainActor
public enum IRViewsTableSectionItem {
    case horizontalTitles([String])
    case spacer(CGFloat)
    
    func toItem() -> IRViewsBaseTableItemProtocol {
        switch self {
        case .horizontalTitles(let titles):
            return IRViewsBaseTableItem(viewModel: IRViewsHorizontalTitlesCellViewModel(titles: titles))
        case .spacer(let height):
            return IRViewsBaseTableItem(viewModel: IRViewsSpacerCellViewModel(height: height))
        }
    }
}
