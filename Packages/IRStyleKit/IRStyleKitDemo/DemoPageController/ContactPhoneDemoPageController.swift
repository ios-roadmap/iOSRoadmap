//
//  ContactPhoneDemoPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 14.04.2025.
//

import IRStyleKit
import UIKit

final class ContactPhoneDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

        let items = [
            ContactPhoneCellViewModel(),
        ]

        let section = IRTableSection(header: .title("Contach Phone"), items: items)
        update(sections: [section])
    }
}
