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
    
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemRed   // kırmızı arka plan
        v.layer.cornerRadius = 8         // isteğe bağlı, yumuşak köşe
        return v
    }()

    // MARK: - Setup
    private func setUpLayout() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            // İçeriğe göre yükseklik belirlenecekse `bottomAnchor` gerekmez
        ])

        containerView.addSubview(contentStack)
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    private func populateRows() {
        let rows: [KeyValueRowView.Model] = [
            .init(
                title: "Kullanıcı Adı",
                description: "En az 6 karakter",
                value: .text("omer_dev"),
                leadingImage: .add
            ),
            .init(
                title: "Profil",
                description: nil,
                value: .text("qwe")
            ),
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
