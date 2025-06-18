//
//  KeyValuePageViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 18.06.2025.
//


import UIKit
import IRStyleKit

public final class KeyValuePageViewController: UIViewController, ShowcaseListViewControllerProtocol {

    // MARK: - UI

    private let scrollView = UIScrollView()
    private let contentStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .fill
        sv.spacing = 16
        return sv
    }()

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ayarlar"
        view.backgroundColor = .systemBackground
        setUpLayout()
        populateRows()
    }

    // MARK: - Setup

    private func setUpLayout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        scrollView.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            // genişlik, scrollView’ın genişliğine eşit kalsın (yatay kayma olmasın)
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }

    private func populateRows() {
        let rows: [KeyValueRowView.Model] = [
            .init(title: "Kullanıcı Adı",
                  description: "En az 6 karakter",
                  value: .text("omer_dev")),
            .init(title: "Profil",
                  description: nil,
                  value: .image(UIImage(systemName: "person") ?? UIImage())),
            .init(title: "Bildirimler",
                  description: "Push izni",
                  value: .button(title: "Aç/Kapat") {
                      print("Bildirim butonu basıldı")
                  })
        ]

        rows.forEach { model in
            let rowView = KeyValueRowView()
            rowView.apply(model)
            contentStack.addArrangedSubview(rowView)
        }
    }
}
