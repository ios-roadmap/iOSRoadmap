//
//  IRJPHUserDetailViewController.swift
//  IRJPH
//
//  Created by Ömer Faruk Öztürk on 9.04.2025.
//

import UIKit

final class IRJPHUserDetailViewController: UIViewController {
    var userName: String
    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        title = userName
    }
}
