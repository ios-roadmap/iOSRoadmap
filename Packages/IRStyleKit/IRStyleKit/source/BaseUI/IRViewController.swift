//
//  IRViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 7.04.2025.
//

import UIKit

open class IRViewController: UIViewController {

    private var isRefreshDataOverridden: Bool {
        let base = class_getInstanceMethod(IRViewController.self, #selector(refreshData))
        let current = class_getInstanceMethod(type(of: self), #selector(refreshData))
        return base != current
    }
    
    private(set) lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("[BaseVC] viewDidLoad")
        setup()
    }

    open func setup() {
        // Alt sınıflar UI setup'larını buraya yazar
    }

    private func makeRefreshControl() -> UIRefreshControl {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refresh
    }

    public func endRefreshing() {
        print("[BaseVC] Ending refresh")
    }

    @objc open func refreshData() {
        // Override by subclass
    }
}

@MainActor
public protocol IRLoadable: AnyObject {
    func setLoading(_ isLoading: Bool)
}

// MARK: Indicator
extension IRViewController: IRLoadable {
    public func setLoading(_ isLoading: Bool) {
        if isLoading {
            view.addSubview(loadingIndicator)
            NSLayoutConstraint.activate([
                loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
            loadingIndicator.removeFromSuperview()
        }
    }
}
