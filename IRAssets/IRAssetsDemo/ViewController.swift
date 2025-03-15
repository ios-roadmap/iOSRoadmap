//
//  ViewController.swift
//  IRAssetsDemo
//
//  Created by Ömer Faruk Öztürk on 14.03.2025.
//

import UIKit
import IRAssets

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        
        imageView.image = IRAssetsImages.Dashboard.jsonPlaceHolder

        view.addSubview(imageView)
    }


}

