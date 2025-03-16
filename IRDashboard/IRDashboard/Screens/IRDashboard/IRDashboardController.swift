//
//  IRDashboardController.swift
//  IRDashboard
//
//  Created by Ömer Faruk Öztürk on 13.03.2025.
//

import UIKit
import IRViews
import IRAssets

final class IRDashboardController: IRViewsBaseTableViewController {
    
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
                            handler: {
                                print("Tapped Rick And Morty")
                            }
                        ),
                    ]
                ))
                .build()
        ]
    }
}
