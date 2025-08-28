//
//  DraggableStackViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 28.08.2025.
//

import UIKit
import IRStyleKit

// MARK: - Drag & Drop Config
public struct DragDropOptions {
    public var enableDragDrop: Bool          // Drag & Drop genel switch
    public var allowReorder: Bool            // Aynı tablo içinde sürükleyip sıralama
    public var allowExternalDrop: Bool       // Uygulama dışından kopya drop

    public init(enableDragDrop: Bool = false,
                allowReorder: Bool = true,
                allowExternalDrop: Bool = true) {
        self.enableDragDrop = enableDragDrop
        self.allowReorder = allowReorder
        self.allowExternalDrop = allowExternalDrop
    }

    public static let disabled = DragDropOptions(enableDragDrop: false,
                                                 allowReorder: false,
                                                 allowExternalDrop: false)
}

// MARK: - Drag & Drop Table VC (Dışarıdan çağırılabilir)
public final class DragDropTableViewController: UIViewController {

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let reuseID = "Cell"

    private var items: [String]
    private var options: DragDropOptions {
        didSet { applyDragDropOptions() }
    }

    // DI: dışarıdan veri ve opsiyonlar verilebilir
    public init(items: [String] = ["Berlin","London","Paris","Istanbul","Tokyo","New York"],
                options: DragDropOptions = .disabled,
                title: String = "Table") {
        self.items = items
        self.options = options
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        applyDragDropOptions()
    }

    // MARK: - Public API (usage VC buradan kullanır)
    public func configure(options: DragDropOptions) {
        self.options = options
    }

    public func appendItem(_ value: String) {
        let newIndex = IndexPath(row: items.count, section: 0)
        items.append(value)
        tableView.performBatchUpdates({
            tableView.insertRows(at: [newIndex], with: .automatic)
        }, completion: nil)
    }

    public func removeLastItem() {
        guard !items.isEmpty else { return }
        let lastIndex = IndexPath(row: items.count - 1, section: 0)
        items.removeLast()
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [lastIndex], with: .automatic)
        }, completion: nil)
    }

    /// Parent’ın yükseklik constraint’i ayarlaması için
    public var contentHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }

    /// Parent, demo senaryosu için scroll’ı kapatıp yükseklikle büyütmek isteyebilir
    public func setScrollEnabled(_ flag: Bool) { tableView.isScrollEnabled = flag }

    // MARK: - Internal
    private func applyDragDropOptions() {
        tableView.dragInteractionEnabled = options.enableDragDrop
        tableView.dragDelegate = options.enableDragDrop ? self : nil
        tableView.dropDelegate = options.enableDragDrop ? self : nil
    }

    private func addItem(_ value: String, at index: Int) {
        let clamped = max(0, min(index, items.count))
        items.insert(value, at: clamped)
    }
}

// MARK: - DataSource / Delegate
extension DragDropTableViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = items[indexPath.row]
        cell.contentConfiguration = config
        return cell
    }

    // Edit-mode reorder (Drag&Drop'tan bağımsız). allowReorder false ise kapalı.
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return options.allowReorder
    }

    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard options.allowReorder, sourceIndexPath != destinationIndexPath else { return }
        let moved = items.remove(at: sourceIndexPath.row)
        items.insert(moved, at: destinationIndexPath.row)
    }
}

// MARK: - UITableViewDragDelegate
extension DragDropTableViewController: UITableViewDragDelegate {
    public func tableView(_ tableView: UITableView,
                          itemsForBeginning session: UIDragSession,
                          at indexPath: IndexPath) -> [UIDragItem] {

        guard options.allowReorder else { return [] }

        let text = items[indexPath.row] as NSString
        let provider = NSItemProvider(object: text)
        let dragItem = UIDragItem(itemProvider: provider)
        dragItem.localObject = text
        return [dragItem]
    }
}

// MARK: - UITableViewDropDelegate
extension DragDropTableViewController: UITableViewDropDelegate {

    public func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        if session.localDragSession != nil { return options.allowReorder }
        if options.allowExternalDrop { return session.canLoadObjects(ofClass: NSString.self) }
        return false
    }

    public func tableView(_ tableView: UITableView,
                          dropSessionDidUpdate session: UIDropSession,
                          withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        guard session.items.count == 1 else { return UITableViewDropProposal(operation: .cancel) }

        if session.localDragSession != nil {
            return options.allowReorder
            ? UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            : UITableViewDropProposal(operation: .cancel)
        } else {
            return options.allowExternalDrop
            ? UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            : UITableViewDropProposal(operation: .cancel)
        }
    }

    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destIndexPath = coordinator.destinationIndexPath ??
        IndexPath(row: tableView.numberOfRows(inSection: max(0, tableView.numberOfSections - 1)),
                  section: max(0, tableView.numberOfSections - 1))

        // 1) Yerel reorder
        if coordinator.proposal.operation == .move,
           options.allowReorder,
           let item = coordinator.items.first,
           let sourceIndexPath = item.sourceIndexPath {

            tableView.performBatchUpdates({
                let moved = items.remove(at: sourceIndexPath.row)
                items.insert(moved, at: destIndexPath.row)
                tableView.moveRow(at: sourceIndexPath, to: destIndexPath)
            }, completion: nil)

            coordinator.drop(item.dragItem, toRowAt: destIndexPath)
            return
        }

        // 2) Harici kopya
        guard options.allowExternalDrop else { return }

        coordinator.session.loadObjects(ofClass: NSString.self) { objects in
            let strings = objects as! [String]
            var indexPaths: [IndexPath] = []

            for (offset, str) in strings.enumerated() {
                let insertIndex = destIndexPath.row + offset
                self.addItem(str, at: insertIndex)
                indexPaths.append(IndexPath(row: insertIndex, section: destIndexPath.section))
            }

            tableView.performBatchUpdates({
                tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
    }
}

// MARK: - Usage (Gerçekten DragDropTableViewController kullanır)
final class UsageExampleViewController: UIViewController, ShowcaseListViewControllerProtocol {

    private let dragDropVC = DragDropTableViewController(
        items: ["Berlin", "London", "Paris"],
        options: .init(enableDragDrop: true, allowReorder: true, allowExternalDrop: false),
        title: "Cities"
    )

    private var heightConstraint: NSLayoutConstraint!

    private let addButton = UIButton(type: .system)
    private let removeButton = UIButton(type: .system)
    private let dragSwitch = UISwitch()
    private let dragLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Usage (Child DragDrop VC)"

        // Child embed
        addChild(dragDropVC)
        dragDropVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dragDropVC.view)
        dragDropVC.didMove(toParent: self)

        // Demo: Table’ın içerik kadar büyümesi için scroll’ı kapat
        dragDropVC.setScrollEnabled(false)

        // UI: Buttons + switch
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        dragSwitch.translatesAutoresizingMaskIntoConstraints = false
        dragLabel.translatesAutoresizingMaskIntoConstraints = false

        addButton.setTitle("+ Add", for: .normal)
        removeButton.setTitle("− Remove", for: .normal)
        dragLabel.text = "Drag & Drop"

        addButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(didTapRemove), for: .touchUpInside)
        dragSwitch.addTarget(self, action: #selector(didToggleDrag(_:)), for: .valueChanged)
        dragSwitch.isOn = true // initial options enableDragDrop: true

        view.addSubview(addButton)
        view.addSubview(removeButton)
        view.addSubview(dragLabel)
        view.addSubview(dragSwitch)

        // Height constraint child view (başlangıçta 1, sonra içerik ile ayarlanacak)
        heightConstraint = dragDropVC.view.heightAnchor.constraint(equalToConstant: 1)
        heightConstraint.isActive = true

        NSLayoutConstraint.activate([
            dragDropVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dragDropVC.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            dragDropVC.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            addButton.topAnchor.constraint(equalTo: dragDropVC.view.bottomAnchor, constant: 12),
            addButton.leadingAnchor.constraint(equalTo: dragDropVC.view.leadingAnchor),

            removeButton.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            removeButton.trailingAnchor.constraint(equalTo: dragDropVC.view.trailingAnchor),

            dragLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 12),
            dragLabel.leadingAnchor.constraint(equalTo: dragDropVC.view.leadingAnchor),

            dragSwitch.centerYAnchor.constraint(equalTo: dragLabel.centerYAnchor),
            dragSwitch.trailingAnchor.constraint(equalTo: dragDropVC.view.trailingAnchor),

            dragSwitch.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        view.layoutIfNeeded()
        updateTableHeight(animated: false)
    }

    @objc private func didTapAdd() {
        dragDropVC.appendItem("Item \(Int.random(in: 1...999))")
        updateTableHeight(animated: true)
    }

    @objc private func didTapRemove() {
        dragDropVC.removeLastItem()
        updateTableHeight(animated: true)
    }

    @objc private func didToggleDrag(_ sender: UISwitch) {
        let newOpts = DragDropOptions(
            enableDragDrop: sender.isOn,
            allowReorder: true,
            allowExternalDrop: false
        )
        dragDropVC.configure(options: newOpts)
    }

    private func updateTableHeight(animated: Bool) {
        let target = dragDropVC.contentHeight
        // İsteğe bağlı üst sınır (örnek: ekranın %60’ı)
        let maxH = view.bounds.height * 0.6
        heightConstraint.constant = min(target, maxH)

        if animated {
            UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
        } else {
            view.layoutIfNeeded()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableHeight(animated: false)
    }
}
