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
                            assetsImage: IRAssets.Dashboard.rickAndMorty,
                            assetsTitle: IRAssets.Dashboard.jsonPlaceHolder
                        )
                    ]
                ))
                .add(.spacer(250))
                .build()
        ]
    }
}

//TODO: tıklanma efektini kaldırmak gerekiyor optional olması lazım.
