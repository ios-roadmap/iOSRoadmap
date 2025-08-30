//
//  CRDragDropTableView.swift
//  CRComponents
//
//  Created by Omer Faruk Ozturk [Ing Teknoloji A.S.-Dijital Squad 1] on 29.08.2025.
//

import UIKit

// MARK: - Eksik Tipler (Tamamlandı)

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

/// Tasarım renkleri (gerekirse kendi paletinize uyarlayın).
public enum CRColor {
    public static let borderSubtle: UIColor = {
        if #available(iOS 13.0, *) { return .separator } // Tema uyumlu ince çizgi
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
        let boundedDest = max(0, min(destination, items.count - 1))
        if source == boundedDest { return }
        let old = items
        let v = items.remove(at: source)
        items.insert(v, at: boundedDest)
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

    /// /// Separator stilini değiştirir ve yapılandırma değişikliğini bildirir.
    public func setSeparatorStyle(_ style: CRSeparatorStyle) {
        separatorStyle = style
        onConfigChanged?()
    }
}

// MARK: - View

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
        tableView.separatorStyle = .none

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
            guard let self = self else { return }
            self.updateHeight()
            // /// Toplu işlem sonrasında görünen satırların separator’larını tazeler.
            self.reloadVisibleForSeparators()
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

    /// /// Verilen indekslerin kendisi ve komşuları için satırları `.none` animasyonla yeniler (separator güncelleme).
    private func reloadSeparatorsAround(indices: [Int]) {
        let rows = Set(indices.flatMap { [$0 - 1, $0, $0 + 1] })
            .filter { $0 >= 0 && $0 < viewModel.items.count }
        guard !rows.isEmpty else { return }
        let ips = rows.sorted().map { IndexPath(row: $0, section: 0) }
        // `beginUpdates/endUpdates` gerekmiyor; .none animasyon güvenli.
        tableView.reloadRows(at: ips, with: .none)
    }

    /// /// Görünür tüm satırları separator konfigürasyonu için hızlıca yeniler.
    private func reloadVisibleForSeparators() {
        let visible = tableView.indexPathsForVisibleRows ?? []
        guard !visible.isEmpty else { return }
        tableView.reloadRows(at: visible, with: .none)
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
        // UIKit satırı görsel olarak taşır; modelimizi senkronize edelim.
        viewModel.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
        // /// Reorder sonrası kaynak/hedef ve komşuları separator için yenile.
        reloadSeparatorsAround(indices: [sourceIndexPath.row, destinationIndexPath.row])
    }

    /// Hücre ekrana gelmeden separator konfigürasyonunu uygular.
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? CRWrapCell else { return }
        let lastRowIndex = max(0, tableView.numberOfRows(inSection: indexPath.section) - 1)
        let isLast = (indexPath.row == lastRowIndex)
        cell.configureSeparator(style: viewModel.separatorStyle, isLastRow: isLast)
    }
}

// MARK: - Drag & Drop

extension CRDragDropTableView: UITableViewDragDelegate, UITableViewDropDelegate {
    /// Sürükleme başlangıcında tek bir yerel öğe üretir.
    public func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard viewModel.allowReorder, viewModel.items.indices.contains(indexPath.row) else { return [] }
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
              viewModel.items.indices.contains(source.row)
        else { return }

        // Hedef indexPath yoksa son sıraya taşı; güvenle sınırla.
        let fallbackRow = max(0, viewModel.items.count - 1)
        let destIP = coordinator.destinationIndexPath ?? IndexPath(row: fallbackRow, section: 0)

        let boundedDestRow = max(0, min(destIP.row, max(0, viewModel.items.count - 1)))
        let boundedDest = IndexPath(row: boundedDestRow, section: 0)

        // Modeli güncelle
        viewModel.moveItem(from: source.row, to: boundedDest.row)

        // UITableView'a bırakmayı bildir (görsel senkron)
        coordinator.drop(item.dragItem, toRowAt: boundedDest)

        // /// Drop sonrası kaynak/hedef ve komşuları separator için yenile.
        reloadSeparatorsAround(indices: [source.row, boundedDest.row])
    }
}

// MARK: - CRWrapCell

public final class CRWrapCell: UITableViewCell {

    /// Hücre kayıt/çözümlemede kullanılacak identifier.
    public static let identifier = "CRWrapCell"

    private let sep = UIView()
    private var sepLeading: NSLayoutConstraint!
    private var sepTrailing: NSLayoutConstraint!

    /// Programatik başlatıcı.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        // Dahili separator görünümü
        sep.translatesAutoresizingMaskIntoConstraints = false
        sep.backgroundColor = CRColor.borderSubtle
        sep.tag = 999
        contentView.addSubview(sep)

        sepLeading = sep.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        sepTrailing = sep.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

        NSLayoutConstraint.activate([
            sep.heightAnchor.constraint(equalToConstant: 1),         // 1pt kalınlık
            sep.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sepLeading,
            sepTrailing
        ])
    }

    /// Storyboard/XIB başlatıcısı desteklenmez.
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// Verilen UIView’i hücreye gömer ve kenarlara sabitler.
    public func embed(_ view: UIView) {
        // Dahili separator haricindeki alt görünümleri temizle
        contentView.subviews
            .filter { $0 !== sep }
            .forEach { $0.removeFromSuperview() }

        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        // Separator en önde kalsın
        contentView.bringSubviewToFront(sep)
    }

    /// /// Hücre separator’ını stil ve "son satır mı" bilgisine göre konfigüre eder.
    public func configureSeparator(style: CRSeparatorStyle, isLastRow: Bool) {
        if isLastRow || style == .none {
            sep.isHidden = true
            return
        }
        sep.isHidden = false
        switch style {
        case .none:
            sep.isHidden = true
        case .full:
            sepLeading.constant = 0
            sepTrailing.constant = 0
        case .withInsets(let insets):
            sepLeading.constant = insets.start
            sepTrailing.constant = -insets.end
        }
        setNeedsLayout()
    }
}
