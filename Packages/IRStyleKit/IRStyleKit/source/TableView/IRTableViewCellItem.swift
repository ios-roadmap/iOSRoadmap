//
//  IRTableViewCellItem.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 31.03.2025.
//

import UIKit
import IRBase

@MainActor
public enum IRTableViewCellItem {
    case spacer(CGFloat, UIColor)
    
    func toItem() -> IRTableViewItemProtocol {
        switch self {
        case .spacer(let height, let backgroundColor):
            return IRTableViewItem(viewModel: IRSpacerCellViewModel(height: height, backgroundColor: backgroundColor))
        }
    }
}
