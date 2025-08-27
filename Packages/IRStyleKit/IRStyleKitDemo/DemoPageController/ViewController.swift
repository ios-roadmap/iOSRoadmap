//
//  ViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 27.08.2025.
//

import UIKit
import IRStyleKit

final class CircleLabelViewDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let circleView = CircleLabelView(frame: CGRect(x: 100, y: 200, width: 80, height: 80))
        circleView.label.text = "DKK"
        circleView.label.textColor = .white
        circleView.label.font = .boldSystemFont(ofSize: 20)
        circleView.circleColor = .systemRed
        
        view.addSubview(circleView)
    }
}
