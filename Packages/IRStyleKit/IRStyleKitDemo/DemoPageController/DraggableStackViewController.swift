//
//  DraggableStackViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 28.08.2025.
//

import UIKit

public final class CRDragDropTableViewModel {
    public private(set) var items: [UIView]
    public private(set) var allowReorder: Bool
    public private(set) var isScrollEnabled: Bool
    public private(set) var matchContentHeight: Bool

    public var onItemsChanged: ((_ old: [UIView], _ new: [UIView]) -> Void)?
    public var onConfigChanged: (() -> Void)?

    /// Modeli verilen öğe listesi ve yapılandırma bayraklarıyla başlatır.
    public init(
        items: [UIView] = [],
        allowReorder: Bool = true,
        isScrollEnabled: Bool = true,
        matchContentHeight: Bool = true
    ) {
        self.items = items
        self.allowReorder = allowReorder
        self.isScrollEnabled = isScrollEnabled
        self.matchContentHeight = matchContentHeight
    }

    /// Öğeleri topluca değiştirir ve değişikliği `onItemsChanged` ile bildirir.
    @discardableResult
    public func setItems(_ newItems: [UIView]) -> Self {
        let old = items
        items = newItems
        onItemsChanged?(old, newItems)
        return self
    }

    /// Listenin sonuna bir UIView ekler ve değişikliği bildirir.
    public func append(_ view: UIView) {
        let old = items
        items.append(view)
        onItemsChanged?(old, items)
    }

    /// Belirtilen indekse bir UIView ekler (taşma/kısmayı güvenli hale getirir) ve değişikliği bildirir.
    public func insert(_ view: UIView, at index: Int) {
        let old = items
        let idx = max(0, min(index, items.count))
        items.insert(view, at: idx)
        onItemsChanged?(old, items)
    }

    /// Listedeki son UIView’i kaldırır, kaldırılan öğeyi döndürür ve değişikliği bildirir.
    @discardableResult
    public func removeLast() -> UIView? {
        guard !items.isEmpty else { return nil }
        let old = items
        let removed = items.removeLast()
        onItemsChanged?(old, items)
        return removed
    }

    /// Verilen indeksteki UIView’i kaldırır ve değişikliği bildirir.
    public func remove(at index: Int) {
        guard items.indices.contains(index) else { return }
        let old = items
        items.remove(at: index)
        onItemsChanged?(old, items)
    }

    /// Bir öğeyi kaynak indeksten hedef indekse taşır ve değişikliği bildirir.
    public func moveItem(from source: Int, to destination: Int) {
        guard items.indices.contains(source) else { return }
        var target = max(0, min(destination, items.count - 1))
        if source == target { return }
        let old = items
        let v = items.remove(at: source)
        items.insert(v, at: target)
        onItemsChanged?(old, items)
    }

    /// Yeniden sıralamayı açıp kapatır ve yapılandırma değişikliğini bildirir.
    public func setAllowReorder(_ flag: Bool) {
        allowReorder = flag
        onConfigChanged?()
    }

    /// Tablo kaydırmasını açıp kapatır ve yapılandırma değişikliğini bildirir.
    public func setScrollEnabled(_ flag: Bool) {
        isScrollEnabled = flag
        onConfigChanged?()
    }

    /// İçerik yüksekliğine uyumu açıp kapatır ve yapılandırma değişikliğini bildirir.
    public func setMatchContentHeight(_ flag: Bool) {
        matchContentHeight = flag
        onConfigChanged?()
    }
}

public final class CRDragDropTableView: UIView {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let viewModel: CRDragDropTableViewModel
    private var heightConstraint: NSLayoutConstraint?

    /// Tablo içerik yüksekliğini hesaplayıp döndürür.
    public var contentHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }

    /// Görünümü verilen viewModel ile kurar, UI’ı hazırlar ve bağları oluşturur.
    public init(viewModel: CRDragDropTableViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        bindViewModel()
        applyConfig()
        updateHeight()
    }

    /// Storyboard/XIB başlatıcısı desteklenmez.
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// Tabloyu ve kısıtlarını kurar, yükseklik kısıtını hazırlar.
    private func setupUI() {
        backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .none
        tableView.register(CRWrapCell.self, forCellReuseIdentifier: CRWrapCell.identifier)

        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let hc = heightAnchor.constraint(equalToConstant: 1)
        hc.priority = .defaultHigh
        hc.isActive = true
        heightConstraint = hc
    }

    /// ViewModel olaylarına abone olur.
    private func bindViewModel() {
        viewModel.onItemsChanged = { [weak self] old, new in
            self?.applyItemsChange(old: old, new: new)
        }
        viewModel.onConfigChanged = { [weak self] in
            self?.applyConfig()
        }
    }

    /// Yapılandırmayı tabloya uygular, yüksekliği günceller.
    private func applyConfig() {
        tableView.isScrollEnabled = viewModel.isScrollEnabled
        tableView.dragInteractionEnabled = viewModel.allowReorder
        applyHeightMode()
        tableView.reloadData()
        updateHeight()
    }

    /// İçerik yüksekliğine uyum modunu aktif/pasif eder ve layout’u yeniler.
    private func applyHeightMode() {
        heightConstraint?.isActive = viewModel.matchContentHeight
        invalidateIntrinsicContentSize()
        superview?.setNeedsLayout()
        superview?.layoutIfNeeded()
    }

    /// Eski ve yeni öğe listelerini karşılaştırıp ekleme/silme/taşıma animasyonlarını uygular.
    private func applyItemsChange(old: [UIView], new: [UIView]) {
        let oldIds = old.map { ObjectIdentifier($0) }
        let newIds = new.map { ObjectIdentifier($0) }

        var deletes: [IndexPath] = []
        var inserts: [IndexPath] = []
        var moves: [(from: IndexPath, to: IndexPath)] = []

        let oldIndexById = Dictionary(uniqueKeysWithValues: oldIds.enumerated().map { ($1, $0) })
        let newIndexById = Dictionary(uniqueKeysWithValues: newIds.enumerated().map { ($1, $0) })

        for (idx, id) in oldIds.enumerated() where newIndexById[id] == nil {
            deletes.append(IndexPath(row: idx, section: 0))
        }
        for (idx, id) in newIds.enumerated() where oldIndexById[id] == nil {
            inserts.append(IndexPath(row: idx, section: 0))
        }
        for (oldIdx, id) in oldIds.enumerated() {
            if let newIdx = newIndexById[id], newIdx != oldIdx {
                moves.append((IndexPath(row: oldIdx, section: 0), IndexPath(row: newIdx, section: 0)))
            }
        }

        tableView.performBatchUpdates({
            if !deletes.isEmpty { tableView.deleteRows(at: deletes, with: .automatic) }
            if !inserts.isEmpty { tableView.insertRows(at: inserts, with: .automatic) }
            for m in moves { tableView.moveRow(at: m.from, to: m.to) }
        }, completion: { [weak self] _ in
            self?.updateHeight()
        })
    }

    /// Tablo içerik yüksekliğine göre görünüm yüksekliğini günceller.
    private func updateHeight() {
        tableView.layoutIfNeeded()
        guard viewModel.matchContentHeight else {
            invalidateIntrinsicContentSize()
            return
        }
        heightConstraint?.constant = max(1, tableView.contentSize.height)
        invalidateIntrinsicContentSize()
        superview?.setNeedsLayout()
        superview?.layoutIfNeeded()
    }

    /// Auto Layout için içsel boyutu içerik yüksekliğine göre sağlar.
    public override var intrinsicContentSize: CGSize {
        tableView.layoutIfNeeded()
        if viewModel.matchContentHeight {
            return CGSize(width: UIView.noIntrinsicMetric, height: max(1, tableView.contentSize.height))
        } else {
            return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
        }
    }
}

extension CRDragDropTableView: UITableViewDataSource, UITableViewDelegate {
    /// Satır sayısını döndürür.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }

    /// İlgili indexPath için hücre döndürür ve hedef UIView’i gömer.
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CRWrapCell.identifier, for: indexPath) as? CRWrapCell else {
            return UITableViewCell()
        }
        cell.embed(viewModel.items[indexPath.row])
        return cell
    }

    /// Satırın taşınabilir olup olmadığını belirtir.
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        viewModel.allowReorder
    }

    /// Bir satır başka bir konuma taşındığında modeldeki sırayı günceller.
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard viewModel.allowReorder, sourceIndexPath != destinationIndexPath else { return }
        viewModel.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

extension CRDragDropTableView: UITableViewDragDelegate, UITableViewDropDelegate {
    /// Sürükleme başlangıcında tek bir yerel öğe üretir.
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard viewModel.allowReorder else { return [] }
        let provider = NSItemProvider()
        let item = UIDragItem(itemProvider: provider)
        item.localObject = viewModel.items[indexPath.row]
        return [item]
    }

    /// Yalnızca yerel sürüklemeleri ve yeniden sıralama iznini kabul eder.
    public func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        session.localDragSession != nil && viewModel.allowReorder
    }

    /// Geçerli durumda taşımaya izin veren bir drop önerisi döndürür.
    public func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        guard session.items.count == 1, session.localDragSession != nil, viewModel.allowReorder else {
            return UITableViewDropProposal(operation: .cancel)
        }
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    /// Bırakma işlemini gerçekleştirir ve modeli yeni sıraya göre günceller.
    public func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard coordinator.proposal.operation == .move,
              viewModel.allowReorder,
              let item = coordinator.items.first,
              let source = item.sourceIndexPath,
              let _ = item.dragItem.localObject as? UIView else { return }

        let dest = coordinator.destinationIndexPath ?? IndexPath(row: viewModel.items.count - 1, section: 0)
        viewModel.moveItem(from: source.row, to: dest.row)
        coordinator.drop(item.dragItem, toRowAt: dest)
    }
}

public final class CRWrapCell: UITableViewCell {

    /// Hücre kayıt/çözümlemede kullanılacak identifier.
    public static let identifier = "CRWrapCell"

    /// Programatik başlatıcı.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    /// Storyboard/XIB başlatıcısı desteklenmez.
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// Verilen UIView’i hücreye gömer ve kenarlara sabitler.
    public func embed(_ view: UIView) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

import UIKit

// MARK: - Minimal satır görünümleri (intrinsic yüksekliği olan)
private func makeRow(_ text: String) -> UIView {
    let label = UILabel()
    label.text = text
    label.numberOfLines = 0
    label.font = .systemFont(ofSize: 16, weight: .medium)

    let container = UIStackView(arrangedSubviews: [label])
    container.axis = .vertical
    container.isLayoutMarginsRelativeArrangement = true
    container.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
    container.backgroundColor = .secondarySystemBackground
    container.layer.cornerRadius = 8
    return container
}

// MARK: - CRDragDropTableView’i kullanan kompakt UIView
final class CompactTableHostView: UIView {

    private let tableHost: CRDragDropTableView
    private let viewModel: CRDragDropTableViewModel

    init(items: [UIView]) {
        // Scroll kapalı -> yükseklik her zaman içerik kadar
        self.viewModel = CRDragDropTableViewModel(items: items,
                                                  allowReorder: true,
                                                  isScrollEnabled: false,
                                                  matchContentHeight: true)
        self.tableHost = CRDragDropTableView(viewModel: viewModel)
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setup() {
        backgroundColor = .clear

        tableHost.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableHost)

        // Kenarlara pinle. Yükseklik için EK kısıt verme; tableHost intrinsic + kendi heightConstraint’i yeterli.
        NSLayoutConstraint.activate([
            tableHost.topAnchor.constraint(equalTo: topAnchor),
            tableHost.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableHost.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableHost.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Üst hiyerarşide şişmemesi için hugging/compression öncelikleri
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
        tableHost.setContentHuggingPriority(.required, for: .vertical)
        tableHost.setContentCompressionResistancePriority(.required, for: .vertical)
    }

    // Dışarıdan içerik güncellemek istersen:
    func setItems(_ views: [UIView]) {
        viewModel.setItems(views)
    }
}

// MARK: - Örnek kullanım (mock UI minimum)
final class UsageExampleViewController: UIViewController, ShowcaseListViewControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Mock data (az ve anlaşılır)
        let rows = [
            makeRow("Birinci satır"),
            makeRow("İkinci satır • daha uzun bir açıklama ile\nİkinci satır devam"),
            makeRow("Üçüncü satır")
        ]

        let compactTable = CompactTableHostView(items: rows)

        // StackView içinde: tablo sadece item yüksekliği kadar yer kaplar
        let stack = UIStackView(arrangedSubviews: [
            sectionHeader("Üst Başlık"),
            compactTable,
            sectionHeader("Alt İçerik (tablo tüm sayfayı kaplamaz)")
        ])
        stack.axis = .vertical
        stack.spacing = 12

        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            // Alt kenarı sabitlemek şart değil; içerik kadar yükseklikle biter.
        ])
    }

    private func sectionHeader(_ text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }
}
