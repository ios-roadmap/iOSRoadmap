//
//  IRDashboardController.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 13.03.2025.
//

import UIKit
import IRStyleKit

final class IRDashboardController: IRViewController {
    
    var navigator: IRDashboardNavigationLogic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let section = IRTableSection(items: [
            IRTextCellViewModel(text: "Json Place Holder", onSelect: { [weak self] in
                self?.navigator.navigateToJPHApp()
            })
        ])
        
        update(sections: [section])
    }
}


