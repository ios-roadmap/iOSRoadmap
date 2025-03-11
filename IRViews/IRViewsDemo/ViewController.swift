import UIKit
import IRViews

class ViewController: IRViewsBaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSections()
    }
    
    private func setupSections() {
        sections = [
            IRViewsBaseTableSectionBuilder()
                .add(IRViewsImageTitleCellViewModel(title: "Omer"))
                .add(IRViewsImageTitleCellViewModel(title: "Omer"))
                .add(IRViewsImageTitleCellViewModel(title: "Omer"))
                .add(IRViewsImageTitleCellViewModel(title: "Omer"))
                .build()
        ]
    }
}
