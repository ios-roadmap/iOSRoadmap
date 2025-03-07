import UIKit
import IRViews
import IRCommon

class ViewController: IRBaseTableView< {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let section = IRTableViewSection(header: "", items: [
            KeyValueRow(systemName: "image1", value: "asd"),
        ])
        
        tableViewSections = [
            section
        ]
    }
}

struct KeyValueRow: IRTableViewItemProtocol {
    var systemName: String
    var value: String
    var tapHandler: IRVoidHandler?

    var cellType: UITableViewCell.Type { IRHorizontalCollectionTableCell.self }

    func configure(cell: UITableViewCell) {
        guard let keyValueCell = cell as? IRHorizontalCollectionTableCell else {
            assertionFailure("Cell is not of type KeyValueCell")
            return
        }
        
        let builder = IRSquareCollectionCellBuilder()
            .setImage("image1")
            .setName("Name")
            .build()
        
        keyValueCell.configure(with: [
            builder,
            builder,
            builder,
            builder,
            builder,
            builder
        ])
    }

}
