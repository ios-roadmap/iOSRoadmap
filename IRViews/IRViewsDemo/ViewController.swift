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
                .add(IRViewsHorizontalTitlesCellViewModel(titles: ["Omer","Omer","Omer","Omer","Omer","Omer","Omer","Omer","Omer","Omer","Omer","Omer"]))
                .build()
        ]
    }
}
