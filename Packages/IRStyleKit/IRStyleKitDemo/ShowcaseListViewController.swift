//
//  ShowcaseListViewController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 26.03.2025.
//

import UIKit
import IRStyleKit

protocol ShowcaseListViewControllerProtocol: UIViewController {
    static var demoTitle: String { get }
}

extension ShowcaseListViewControllerProtocol {
    static var demoTitle: String {
        String(describing: Self.self)
    }
}

final class ShowcaseListViewController: IRViewController {
    private let demoPages: [ShowcaseListViewControllerProtocol.Type] = [
        //TODO: Daha konulara bölünmesi gerekiliyor. Özel çalışma yapılması lazım.
        SegmentPageController.self,
        CoachmarkDemoPageController.self,
        ContactPhoneDemoPageController.self,
        TableDemoPageController.self,
        TextLabelDemoPageController.self,
        ButtonDemoPageController.self,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "IRStyleKit Showcase"
    }

    override func setup() {
        let tv = TableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tv)  // Bunu mutlaka ekle!
        
        tv.update(sections: [
            TableSection(header: .title("Pages"), items: demoPages.map { pageType in
                IRTextCellViewModel(text: pageType.demoTitle) { [weak self] in
                    let vc = pageType.init()
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            })
        ])
        
        view.fit(subView: tv)
    }

}
