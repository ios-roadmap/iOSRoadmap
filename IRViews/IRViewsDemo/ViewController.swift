// Kullanım
import IRViews
import IRAssets

class ViewController: IRViewsBaseTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSections()
    }
    
    private func setupSections() {
        view.backgroundColor = .white
        
        sections = [
            IRViewsBaseTableSectionBuilder()
                .add(.spacer(250))
                .add(.imageButtonViews(
                    [
                        .init(
                            image: IRAssetsImages.Dashboard.rickAndMortyApp,
                            title: "Rick And Morty App")
                    ]
                ))
                .add(.spacer(250))
                .build()
        ]
    }
}
