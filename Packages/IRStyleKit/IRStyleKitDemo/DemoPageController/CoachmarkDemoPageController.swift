//
//  CoachmarkDemoPageController.swift
//  IRStyleKitDemo
//
//  Created by Ömer Faruk Öztürk on 11.04.2025.
//

import UIKit
import IRStyleKit

final class CoachmarkDemoPageController: IRViewController, ShowcaseListViewControllerProtocol {

    private lazy var coachmarkView: IRCoachmarkView = {
        let data = IRCoachmarkPageData(
            title: "Kısayollar",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
            numberOfPages: 5,
            pageIndex: 1,
            triangleViewMidX: 120,
            direction: .top,
            actionButtonTitle: "Devam"
        )
        let view = IRCoachmarkView(pageData: data)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(coachmarkView)
        
        NSLayoutConstraint.activate([
            coachmarkView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            coachmarkView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            coachmarkView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
        
        coachmarkView.show()
    }
}

extension CoachmarkDemoPageController: IRCoachmarkViewDelegate {
    func actionDidTapped(_ view: IRCoachmarkView, index: Int) {
        print("Tamam tapped, index: \(index)")
        view.hide()
    }
    
    func closeDidTapped(_ view: IRCoachmarkView) {
        print("Kapat tapped")
        view.hide()
    }
}
