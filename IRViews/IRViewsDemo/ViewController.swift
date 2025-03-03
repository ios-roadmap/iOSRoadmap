import UIKit
import IRViews

class ViewController: UIViewController {
    private let presenter = IRMaskedInputFieldDelegate(
        formatter: .generic,
        maskDefinition: IRMaskDefinition(
            patternType: .iban
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let cardTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 400, height: 40))
        cardTextField.borderStyle = .roundedRect
        cardTextField.keyboardType = .numberPad
        cardTextField.text = presenter.placeholder
        cardTextField.delegate = presenter
        
        view.addSubview(cardTextField)
    }
}
