//
//  DraggableStackViewController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 28.08.2025.
//

import UIKit
import IRStyleKit

/// CRDragDropTableViewModel:
/// - CRDragDropTableView için veri kaynağını ve konfigürasyon durumunu yönetir.
/// - items: Tabloda görüntülenecek UIView listesi.
/// - allowReorder: Sürükle-bırak ile yeniden sıralama izni.
/// - isScrollEnabled: Tablo kaydırma izni.
/// - onItemsChanged: İçerik değiştiğinde tabloya bildirim göndermek için callback.
/// - onConfigChanged: Konfigürasyon değiştiğinde tabloya bildirim göndermek için callback.
public final class CRDragDropTableViewModel {
    
    /// Tabloya gömülecek UIView listesi.
    public private(set) var items: [UIView]
    /// Yeniden sıralama izni.
    public private(set) var allowReorder: Bool
    /// Kaydırma izni.
    public private(set) var isScrollEnabled: Bool

    /// İçerik değişiminde (eski ve yeni öğelerle) tetiklenen callback.
    public var onItemsChanged: ((_ old: [UIView], _ new: [UIView]) -> Void)?
    /// Konfigürasyon değişiminde tetiklenen callback.
    public var onConfigChanged: (() -> Void)?

    /// Başlatıcı — başlangıç öğeleri ve konfigürasyon alınır.
    public init(items: [UIView] = [], allowReorder: Bool = true, isScrollEnabled: Bool = true) {
        self.items = items
        self.allowReorder = allowReorder
        self.isScrollEnabled = isScrollEnabled
    }

    // MARK: - Public API — içerik yönetimi

    /// Öğeleri topluca günceller.
    /// - Callback ile eski ve yeni listeyi bildirir.
    @discardableResult
    public func setItems(_ newItems: [UIView]) -> Self {
        let old = items
        items = newItems
        onItemsChanged?(old, newItems)
        return self
    }

    /// Liste sonuna yeni öğe ekler.
    public func append(_ view: UIView) {
        let old = items
        items.append(view)
        onItemsChanged?(old, items)
    }

    /// Belirtilen index’e yeni öğe ekler (sınır dışıysa uygun aralığa sıkıştırılır).
    public func insert(_ view: UIView, at index: Int) {
        let old = items
        let idx = max(0, min(index, items.count))
        items.insert(view, at: idx)
        onItemsChanged?(old, items)
    }

    /// Son öğeyi siler ve döner.
    /// - Liste boşsa nil döner.
    @discardableResult
    public func removeLast() -> UIView? {
        guard !items.isEmpty else { return nil }
        let old = items
        let removed = items.removeLast()
        onItemsChanged?(old, items)
        return removed
    }

    /// Belirtilen index’teki öğeyi siler.
    public func remove(at index: Int) {
        guard items.indices.contains(index) else { return }
        let old = items
        items.remove(at: index)
        onItemsChanged?(old, items)
    }

    /// Bir öğeyi verilen kaynaktan hedef index’e taşır.
    /// - Index sınırları kontrol edilir.
    /// - Aynı pozisyona taşınıyorsa işlem yapılmaz.
    public func moveItem(from source: Int, to destination: Int) {
        guard items.indices.contains(source) else { return }
        var target = destination
        target = max(0, min(target, items.count - 1))
        if source == target { return }
        let old = items
        let view = items.remove(at: source)
        items.insert(view, at: target)
        onItemsChanged?(old, items)
    }

    // MARK: - Public API — konfigürasyon

    /// Yeniden sıralama iznini değiştirir ve callback tetikler.
    public func setAllowReorder(_ flag: Bool) {
        allowReorder = flag
        onConfigChanged?()
    }

    /// Kaydırma iznini değiştirir ve callback tetikler.
    public func setScrollEnabled(_ flag: Bool) {
        isScrollEnabled = flag
        onConfigChanged?()
    }
}

// MARK: - View
/// CRDragDropTableView:
/// - UITableView tabanlı, sürükle-bırak ile yeniden sıralamayı destekleyen kapsayıcı UIView.
/// - Görünüm (tableView) ve durum (viewModel) ayrımı vardır.
/// - viewModel sinyalleri ile tablo içeriği ve konfigürasyonu güncellenir.
public final class CRDragDropTableView: UIView {
    
    /// İçteki tablo görünümü (plain stil).
    private let tableView = UITableView(frame: .zero, style: .plain)
    /// İçerik listesi, konfigürasyon ve geri çağrıları yöneten model.
    private let viewModel: CRDragDropTableViewModel

    /// Geçerli içerik yüksekliği (layoutIfNeeded ile güncel contentSize).
    public var contentHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }

    /// Başlatıcı: ViewModel alınır, UI kurulur, bağlar yapılır, konfigürasyon uygulanır.
    public init(viewModel: CRDragDropTableViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        bindViewModel()
        applyConfig()
    }

    /// Interface Builder kullanılmadığı için zorunlu başlatıcı devre dışı.
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    /// UI kurulumu:
    /// - Arka plan rengi
    /// - tableView temel özellikler (delegate/dataSource/drag/drop)
    /// - Otomatik boyutlanan satırlar
    /// - Ayırıcılar kapalı
    /// - Hücre kaydı
    /// - Kenarlara pinlenen Auto Layout kısıtları
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
    }

    /// ViewModel bağlama:
    /// - onItemsChanged: eski ve yeni öğe listesine göre tabloyu minimal değişikliklerle günceller.
    /// - onConfigChanged: scroll/drag gibi konfigürasyonları yeniden uygular.
    private func bindViewModel() {
        viewModel.onItemsChanged = { [weak self] old, new in
            self?.applyItemsChange(old: old, new: new)
        }
        viewModel.onConfigChanged = { [weak self] in
            self?.applyConfig()
        }
    }

    /// Konfigürasyon uygulama:
    /// - Kaydırma izni
    /// - Drag etkileşimi (reorder için)
    /// - Tam yeniden yükleme (basitliği/tek kaynaktan doğruluğu tercih eder)
    private func applyConfig() {
        tableView.isScrollEnabled = viewModel.isScrollEnabled
        tableView.dragInteractionEnabled = viewModel.allowReorder
        tableView.reloadData()
    }

    /// Öğeler değiştiğinde farklılıkları hesaplayıp toplu tablo güncellemesi yapar.
    /// - Kimlik belirleme: UIView için ObjectIdentifier kullanılır (referans eşitliği).
    /// - Çıktı: silmeler, eklemeler, taşımalar.
    /// - performBatchUpdates: UI senkron ve animasyonlu güncellenir.
    private func applyItemsChange(old: [UIView], new: [UIView]) {
        /// Eski/Yeni kimlik listeleri.
        let oldIds = old.map { ObjectIdentifier($0) }
        let newIds = new.map { ObjectIdentifier($0) }

        /// Fark kümeleri.
        var deletes: [IndexPath] = []
        var inserts: [IndexPath] = []
        var moves: [(from: IndexPath, to: IndexPath)] = []

        /// Hızlı indeks erişimi için sözlükler (id -> index).
        let oldIndexById = Dictionary(uniqueKeysWithValues: oldIds.enumerated().map { ($1, $0) })
        let newIndexById = Dictionary(uniqueKeysWithValues: newIds.enumerated().map { ($1, $0) })

        /// Silinecekler: eski listede olup yeni listede olmayanlar.
        for (idx, id) in oldIds.enumerated() where newIndexById[id] == nil {
            deletes.append(IndexPath(row: idx, section: 0))
        }

        /// Eklenecekler: yeni listede olup eski listede olmayanlar.
        for (idx, id) in newIds.enumerated() where oldIndexById[id] == nil {
            inserts.append(IndexPath(row: idx, section: 0))
        }

        /// Taşınacaklar: her iki listede de bulunan ama index’i değişmiş olanlar.
        for (oldIdx, id) in oldIds.enumerated() {
            if let newIdx = newIndexById[id], newIdx != oldIdx {
                moves.append((IndexPath(row: oldIdx, section: 0), IndexPath(row: newIdx, section: 0)))
            }
        }

        /// Toplu güncelleme: sil, ekle ve satır taşıma animasyonları.
        tableView.performBatchUpdates({
            if !deletes.isEmpty { tableView.deleteRows(at: deletes, with: .automatic) }
            if !inserts.isEmpty { tableView.insertRows(at: inserts, with: .automatic) }
            for m in moves { tableView.moveRow(at: m.from, to: m.to) }
        }, completion: nil)
    }
}

// MARK: - DataSource / Delegate
/// UITableView veri kaynağı ve etkileşimlerini yöneten uzantı.
/// Hücreleri CRWrapCell ile oluşturur ve viewModel.items içeriğini gösterir.
/// Yeniden sıralama (reorder) izni viewModel.allowReorder ile kontrol edilir.
extension CRDragDropTableView: UITableViewDataSource, UITableViewDelegate {

    /// Bölümde kaç satır olacağını belirtir.
    /// - Dönen değer: viewModel.items.count (mevcut öğe sayısı)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }

    /// Belirtilen indexPath için hücre oluşturur/yeniden kullanır ve içerik gömer.
    /// - Hücre tipi: CRWrapCell
    /// - İçerik: viewModel.items[indexPath.row] içindeki UIView
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CRWrapCell.identifier, for: indexPath) as? CRWrapCell else {
            return UITableViewCell()
        }
        let view = viewModel.items[indexPath.row]
        /// CRWrapCell içinde verilen UIView'ı hiyerarşiye ekler/yerleştirir.
        cell.embed(view)
        return cell
    }

    /// İlgili satırın hareket ettirilebilir (reorder) olup olmadığını bildirir.
    /// - Koşul: Sadece viewModel.allowReorder true ise taşınabilir.
    public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        viewModel.allowReorder
    }

    /// Bir satır farklı bir konuma taşındığında veri kaynağını günceller.
    /// - Amaç: Modeldeki öğeyi eski konumdan yeni konuma taşımak.
    /// - Not: Aynı konuma taşınma veya izin yoksa işlem yapılmaz.
    public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard viewModel.allowReorder, sourceIndexPath != destinationIndexPath else { return }
        viewModel.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

// MARK: - Drag & Drop
/// UITableView için drag & drop davranışlarını yöneten delegate uzantısı.
/// Sadece yerel (aynı uygulama içi) sürüklemeye ve yeniden sıralamaya izin verir.
/// viewModel.allowReorder false ise tüm işlemler engellenir.
extension CRDragDropTableView: UITableViewDragDelegate, UITableViewDropDelegate {

    /// Kullanıcı bir satırı sürüklemeye başladığında çağrılır.
    /// - Amaç: Sürüklemeye konu olacak veriyi (UIDragItem) üretmek.
    /// - Eğer yeniden sıralama kapalıysa boş dizi döner ve sürükleme başlamaz.
    /// - localObject: Satırın model nesnesini yerel taşıma için ekler (cross-app değil).
    public func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        /// Yeniden sıralama izni yoksa sürükleme başlatma.
        guard viewModel.allowReorder else {
            return []
        }

        /// iOS drag & drop API’si bir NSItemProvider ister; yerel kullanımda içeriği doldurmak şart değil.
        let provider = NSItemProvider()
        let dragItem = UIDragItem(itemProvider: provider)

        /// Yerel taşıma için asıl veriyi localObject ile taşırız.
        dragItem.localObject = viewModel.items[indexPath.row]
        return [dragItem]
    }

    /// Bu drop oturumunun işlenip işlenemeyeceğini belirtir.
    /// - Sadece yerel sürükleme (aynı app içinde) ve yeniden sıralama açıksa true döner.
    public func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        session.localDragSession != nil && viewModel.allowReorder
    }

    /// Sürükleme hedefi üzerinde her konum güncellendiğinde çağrılır.
    /// - Amaç: Hangi işlem türüne (move/cancel) ve niyete (insertAtDestinationIndexPath) izin verileceğini bildirmek.
    /// - Kısıt: Yalnızca tek bir öğe ve yerel sürükleme kabul edilir; aksi halde iptal.
    public func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UITableViewDropProposal {
        guard session.items.count == 1, session.localDragSession != nil, viewModel.allowReorder else {
            return UITableViewDropProposal(operation: .cancel)
        }
        /// insertAtDestinationIndexPath: Satırı hedef indexPath’e yerleştir.
        return UITableViewDropProposal(
            operation: .move,
            intent: .insertAtDestinationIndexPath
        )
    }

    /// Bırakma işlemi gerçekleştiğinde çağrılır.
    /// - Amaç: Veri kaynağını (viewModel) ve tablo görünümünü senkron şekilde güncellemek ve drop’u tamamlamak.
    public func tableView(
        _ tableView: UITableView,
        performDropWith coordinator: UITableViewDropCoordinator
    ) {
        /// Yalnızca move işlemini ve izin açık durumunu kabul et.
        /// sourceIndexPath: Sürüklenen satırın eski konumu.
        /// localObject tür kontrolü: Yalnızca beklenen tipte yerel sürüklemeleri işlemek için örnek kontrolü.
        guard coordinator.proposal.operation == .move,
              viewModel.allowReorder,
              let item = coordinator.items.first,
              let sourceIndexPath = item.sourceIndexPath,
              let _ = item.dragItem.localObject as? UIView else { return }

        /// Hedef indexPath yoksa (ör. listenin altına bırakma) son satırı hedefle.
        let dest = coordinator.destinationIndexPath ?? IndexPath(row: viewModel.items.count - 1, section: 0)

        /// Hem veri modelini hem de tabloyu atomik şekilde güncelle.
        tableView.performBatchUpdates({
            /// Önce modelde öğeyi yeni konuma taşı.
            viewModel.moveItem(from: sourceIndexPath.row, to: dest.row)
            /// Sonra tabloda satırı görsel olarak taşı.
            tableView.moveRow(at: sourceIndexPath, to: dest)
        }, completion: nil)

        /// UIKit’e drop’un satır hedefinde tamamlandığını bildir (animasyon/senkronizasyon için).
        coordinator.drop(item.dragItem, toRowAt: dest)
    }
}

// MARK: - Wrap Cell
/// CRWrapCell:
/// - UITableViewCell içinde herhangi bir UIView’i sarmalayarak göstermek için kullanılır.
/// - Yeniden kullanılabilir hücre kimliği `identifier`
/// - selectionStyle = .none (satır seçildiğinde highlight edilmez)
public final class CRWrapCell: UITableViewCell {
    
    /// Hücre kayıt/çözümlemede kullanılacak identifier
    public static let identifier = "CRWrapCell"
    
    /// Başlatıcı (programatik kullanım için)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        /// Satır seçildiğinde highlight olmaması için
        selectionStyle = .none
    }
    
    /// Storyboard/XIB kullanılmadığı için devre dışı
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    /// Verilen UIView’i hücreye gömer.
    /// - Önce contentView içindeki tüm alt görünümler kaldırılır.
    /// - Sonra yeni view eklenir ve kenarlara pinlenir.
    public func embed(_ view: UIView) {
        /// Öncekileri temizle
        contentView.subviews.forEach {
            $0.removeFromSuperview()
        }
        /// Auto Layout için hazırlık
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        /// Dört kenara pinleme
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}


// MARK: - ViewController Example
final class UsageExampleViewController: UIViewController, ShowcaseListViewControllerProtocol {
    private var dragDropView: CRDragDropTableView!
    private var viewModel: CRDragDropTableViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Örnek içerik: Label + Button
        let v1 = makeLabel("Item 1")
        let v2 = makeLabel("Item 2")
        let v3 = makeButton("Tap Me")

        viewModel = CRDragDropTableViewModel(items: [v1, v2, v3], allowReorder: true, isScrollEnabled: true)
        dragDropView = CRDragDropTableView(viewModel: viewModel)
        dragDropView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(dragDropView)
        NSLayoutConstraint.activate([
            dragDropView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dragDropView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dragDropView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dragDropView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addItem)),
            UIBarButtonItem(title: "Toggle Scroll", style: .plain, target: self, action: #selector(toggleScroll))
        ]
    }

    @objc private func addItem() {
        let newView = makeLabel("Item \(viewModel.items.count + 1)")
        viewModel.append(newView)
    }

    @objc private func toggleScroll() {
        viewModel.setScrollEnabled(!viewModel.isScrollEnabled)
    }

    // Helpers
    private func makeLabel(_ text: String) -> UIView {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.backgroundColor = .secondarySystemBackground
        return label
    }

    private func makeButton(_ title: String) -> UIView {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }

    @objc private func buttonTapped() {
        print("Button tapped!")
    }
}
