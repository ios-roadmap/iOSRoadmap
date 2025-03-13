// Kullanım
import IRViews

class ViewController: IRViewsBaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSections()
    }
    
    private func setupSections() {
        view.backgroundColor = .white
        
        sections = [
            IRViewsBaseTableSectionBuilder()
                .add(.horizontalTitles(["Omer", "Omer", "Omer", "Omer", "Omer"]))
                .add(.spacer(250))
                .add(.horizontalTitles(["Omer", "Omer", "Omer", "Omer", "Omer"]))
                .build()
        ]
    }
}
