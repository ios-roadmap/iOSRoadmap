//
//  DraggableStackViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 28.08.2025.
//

import UIKit
import IRStyleKit

// MARK: - 1) İki farklı custom UIView

final class AccountView: UIView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let vStack = UIStackView()

    init(title: String, subtitle: String) {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12
        layer.masksToBounds = true

        vStack.axis = .vertical
        vStack.spacing = 6
        vStack.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .preferredFont(forTextStyle: .headline)
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel

        titleLabel.text = title
        subtitleLabel.text = subtitle

        addSubview(vStack)
        [titleLabel, subtitleLabel].forEach(vStack.addArrangedSubview)

        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

final class InfoView: UIView {
    private let label = UILabel()

    init(text: String) {
        super.init(frame: .zero)
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 12
        layer.masksToBounds = true

        label.text = text
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - 2) View’leri host edecek minimalist hücre
// Hücrenin görevi sadece verilen UIView’i contentView’e pin’lemek.
final class HostCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func host(_ view: UIView) {
        // Reuse güvenliği
        contentView.subviews.forEach { $0.removeFromSuperview() }

        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

// MARK: - 3) ViewController
final class DraggableStackViewController: UIViewController, ShowcaseListViewControllerProtocol {

    private let tableView = UITableView(frame: .zero, style: .plain)

    // Reorder edilecek KAYNAK **UIView dizisi** (cell’den bağımsız)
    private var rows: [UIView] = [
        AccountView(title: "4447069-MT11", subtitle: "Vadeli TL"),
        InfoView(text: "4447069-MT12 (Vadesiz TL)")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HostCell.self, forCellReuseIdentifier: "HostCell")
        tableView.dataSource = self
        tableView.delegate = self

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72

        tableView.isEditing = true                 // reorder aktif
        tableView.allowsSelectionDuringEditing = true

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension DraggableStackViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows.count }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HostCell",
                                                 for: indexPath) as! HostCell
        // Hazır UIView instance’ını host et
        let view = rows[indexPath.row]
        cell.host(view)
        return cell
    }

    // Reorder izin
    func tableView(_ tableView: UITableView,
                   canMoveRowAt indexPath: IndexPath) -> Bool { true }

    // Reorder sonrası UIView dizisini güncelle
    func tableView(_ tableView: UITableView,
                   moveRowAt sourceIndexPath: IndexPath,
                   to destinationIndexPath: IndexPath) {
        let moved = rows.remove(at: sourceIndexPath.row)
        rows.insert(moved, at: destinationIndexPath.row)
    }

    // İsteğe bağlı: edit kontrol butonunu gizlemek için (sürükleme handle kalsın)
    func tableView(_ tableView: UITableView,
                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle { .none }
}
