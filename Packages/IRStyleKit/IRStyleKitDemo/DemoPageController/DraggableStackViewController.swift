//
//  CRDragDropTableView.swift
//  CRComponents
//
//  Created by Omer Faruk Ozturk [Ing Teknoloji A.S.-Dijital Squad 1] on 29.08.2025.
//

import UIKit

// MARK: - Tamamlayıcı Tipler

/// Separator çizgisi stili.
public enum CRSeparatorStyle: Equatable {
    case none
    case full
    case withInsets(CRSeparatorInsets)
}

/// Separator iç/dış boşlukları.
public struct CRSeparatorInsets: Equatable {
    public let start: CGFloat
    public let end: CGFloat
    public init(start: CGFloat, end: CGFloat) {
        self.start = start
        self.end = end
    }
}

/// Basit renk paleti.
public enum CRColor {
    public static let borderSubtle: UIColor = {
        if #available(iOS 13.0, *) { return .separator }
        return UIColor(white: 0.85, alpha: 1.0)
    }()
}

// MARK: - ViewModel

public final class CRDragDropTableViewModel {

    public private(set) var items: [UIView]
    public private(set) var allowReorder: Bool
    public private(set) var isScrollEnabled: Bool
    public private(set) var matchContentHeight: Bool
    public private(set) var separatorStyle: CRSeparatorStyle

    public var onItemsChanged: ((_ old: [UIView], _ new: [UIView]) -> Void)?
    public var onConfigChanged: (() -> Void)?

    /// Modeli verilen öğe listesi ve yapılandırma bayraklarıyla başlatır.
    public init(
        items: [UIView] = [],
        allowReorder: Bool = true,
        isScrollEnabled: Bool = true,
        matchContentHeight: Bool = true,
        separatorStyle: CRSeparatorStyle = .none
    ) {
        self.items = items
        self.allowReorder = allowReorder
        self.isScrollEnabled = isScrollEnabled
        self.matchContentHeight = matchContentHeight
        self.separatorStyle = separatorStyle
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

// MARK: - CRDragDropTableView

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
        tableView.estimatedRowHeight = 150
        tableView.register(CRWrapCell.self, forCellReuseIdentifier: CRWrapCell.identifier)
        tableView.separatorStyle = .none // manuel separator kullanılacak

        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let hc = heightAnchor.constraint(equalToConstant: 1)
        hc.priority = .required
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
        DispatchQueue.main.async { [weak self] in
            self?.refreshSeparators()
            self?.updateHeight()
        }
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
            self?.refreshSeparators()
            self?.updateHeight()
        })
    }

    /// Görünür hücrelerin separator durumunu günceller (drag/drop veya move sonrası tekrar çizim).
    private func refreshSeparators() {
        let rows = tableView.numberOfRows(inSection: 0)
        guard rows > 0 else { return }

        for cell in tableView.visibleCells {
            // Eski çizgileri temizle
            cell.contentView.subviews
                .filter { $0.tag == 999 }
                .forEach { $0.removeFromSuperview() }

            guard let ip = tableView.indexPath(for: cell),
                  ip.row < rows - 1 else { continue } // son satır için çizme

            switch viewModel.separatorStyle {
            case .none:
                break
            case .full:
                addSeparator(to: cell, start: 0, end: 0)
            case .withInsets(let insets):
                addSeparator(to: cell, start: insets.start, end: insets.end)
            }
        }
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

// MARK: - UITableViewDataSource & UITableViewDelegate

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
        // Görünürken hareket ediyorsa willDisplay tetiklenmeyebilir; separator'ları yenile
        DispatchQueue.main.async { [weak self] in self?.refreshSeparators() }
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.separatorStyle = .none

        let lastRowIndex = tableView.numberOfRows(inSection: indexPath.section) - 1
        guard indexPath.row != lastRowIndex else {
            // Son hücrede separator ekleme
            cell.contentView.subviews
                .filter { $0.tag == 999 }
                .forEach { $0.removeFromSuperview() }
            return
        }

        switch viewModel.separatorStyle {
        case .none:
            break
        case .full:
            addSeparator(to: cell, start: 0, end: 0)
        case .withInsets(let insets):
            addSeparator(to: cell, start: insets.start, end: insets.end)
        }
    }

    private func addSeparator(to cell: UITableViewCell, start: CGFloat, end: CGFloat) {
        // Önce varsa eski separator'ı temizle
        cell.contentView.subviews
            .filter { $0.tag == 999 }
            .forEach { $0.removeFromSuperview() }

        let line = UIView()
        line.backgroundColor = CRColor.borderSubtle
        line.tag = 999
        cell.contentView.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 1), // 1pt kalınlık
            line.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: start),
            line.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -end),
            line.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
        ])
    }
}

// MARK: - Drag & Drop

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

        // Drop sonrası separator durumunu yenile
        DispatchQueue.main.async { [weak self] in self?.refreshSeparators() }
    }
}

// MARK: - CRWrapCell

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

    /// Reuse öncesi varsa manuel separator'ı temizle.
    public override func prepareForReuse() {
        super.prepareForReuse()
        contentView.subviews.filter { $0.tag == 999 }.forEach { $0.removeFromSuperview() }
    }

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

// MARK: - Usage Example

final class UsageExampleViewController: UIViewController, ShowcaseListViewControllerProtocol {

    private var dragDropView: CRDragDropTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Örnek içerik: 3 label
        let views: [UIView] = [
            makeRow(text: "Birinci Satır"),
            makeRow(text: "İkinci Satır"),
            makeRow(text: "Üçüncü Satır")
        ]

        // ViewModel: separator style with insets
        let vm = CRDragDropTableViewModel(
            items: views,
            allowReorder: true,
            isScrollEnabled: true,
            matchContentHeight: true,
            separatorStyle: .withInsets(CRSeparatorInsets(start: 16, end: 16))
        )

        dragDropView = CRDragDropTableView(viewModel: vm)
        dragDropView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(dragDropView)

        NSLayoutConstraint.activate([
            dragDropView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dragDropView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dragDropView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            // yükseklik matchContentHeight olduğu için otomatik ayarlanır
        ])
    }

    /// Basit label içeren satır view
    private func makeRow(text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.backgroundColor = UIColor.secondarySystemBackground
        label.textAlignment = .left
        label.numberOfLines = 0
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        let container = UIView()
        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12)
        ])
        return container
    }
}
