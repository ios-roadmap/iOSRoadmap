//
//  ViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 27.08.2025.
//

import UIKit
import IRStyleKit

final class CircleLabelViewDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {
    
    var viewModel: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let vm = CircleLabelImageViewModel(
            text: "DKK",
            textColor: .white,
            font: .boldSystemFont(ofSize: 20),
            circleColor: .systemRed,
            size: CGSize(width: 80, height: 80)
        )
        
        let image = CircleLabelImage(viewModel: vm)
        let imageView = UIImageView(image: image)
        imageView.center = view.center
        
        view.addSubview(imageView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel = ViewModel(view: self)
    }
}

final class ViewModel {
    
    let view: UIViewController
    
    init(view: UIViewController) {
        self.view = view
    }
}
