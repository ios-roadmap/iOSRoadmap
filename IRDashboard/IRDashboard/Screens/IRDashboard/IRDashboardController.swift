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
                        .init(image: IRAssetsImages.Dashboard.jsonPlaceHolder, title: IRAssetsStrings.Dashboard.jsonPlaceHolder) {
                            print("Tapped")
                        },
                        .init(image: IRAssetsImages.Dashboard.rickAndMorty, title: IRAssetsStrings.Dashboard.rickAndMorty) {
                            print("Tapped Rick And Morty")
                        }
                    ]
                ))
                .add(.imageButtonViews([
                    .init(image: IRAssetsImages.Main.appIcon, title: "asd") {
                        print("asd")
                    }
                ]))
                .build()
        ]
    }
}
