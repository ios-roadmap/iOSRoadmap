//
//  IRDashboardController.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 13.03.2025.
//

import UIKit
import IRViews
import IRAssets

import IRCore

final class IRDashboardController: IRViewsBaseTableViewController {
    
    var navigator: IRDashboardNavigationLogic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        sections = [
            IRViewsBaseTableSectionBuilder()
                .add(.imageButtonViews(
                    [
                        .init(
                            assetsImage: IRAssets.Dashboard.rickAndMorty,
                            assetsTitle: IRAssets.Dashboard.rickAndMorty,
                            handler: {
                                print("Tapped Rick And Morty")
                            }
                        ),
                        .init(
                            assetsImage: IRAssets.Dashboard.jsonPlaceHolder,
                            assetsTitle: IRAssets.Dashboard.jsonPlaceHolder,
                            handler: { [weak self] in
                                self?.navigator.navigateToJPHApp()
                            }
                        ),
                    ]
                ))
                .build()
        ]
    }
}


