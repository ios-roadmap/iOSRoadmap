//
//  IRViewsBaseViewController.swift
//  IRViews
//
//  Created by Ömer Faruk Öztürk on 18.03.2025.
//

import UIKit

open class IRViewsBaseViewController: UIViewController {

    public static let viewControllerWillDisappearNotification = Notification.Name("IRViewsBaseViewControllerWillDisappear")

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        print("ÖMER")
    }
}
