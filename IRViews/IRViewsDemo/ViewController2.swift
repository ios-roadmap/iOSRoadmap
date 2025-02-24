//import UIKit
//
//class ViewController: UIViewController {
//    
//    let cardTextField: UITextField = {
//        let textField = UITextField()
//        textField.borderStyle = .roundedRect
//        textField.keyboardType = .numberPad
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//    
//    let secureFormatter = SecureCardFormatter()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//
//        view.addSubview(cardTextField)
//        cardTextField.delegate = secureFormatter
//
//        NSLayoutConstraint.activate([
//            cardTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            cardTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            cardTextField.widthAnchor.constraint(equalToConstant: 250)
//        ])
//    }
//}
//
//import UIKit
//
//class SecureCardFormatter: NSObject, UITextFieldDelegate {
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else { return true }
//        
//        let newText = (text as NSString).replacingCharacters(in: range, with: string)
//        
//        let digits = newText.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
//        
//        let trimmed = String(digits.prefix(10))
//        
//        var formatted = ""
//        
//        if trimmed.count <= 4 {
//            formatted = trimmed
//        } else if trimmed.count <= 6 {
//            let first4 = trimmed.prefix(4)
//            let lastPart = trimmed.suffix(trimmed.count - 4)
//            formatted = "\(first4) \(lastPart)"
//        } else if trimmed.count <= 10 {
//            let first4 = trimmed.prefix(4)
//            let middle2 = trimmed.dropFirst(4).prefix(2)
//            let lastPart = trimmed.dropFirst(6).prefix(trimmed.count - 6)
//            formatted = "\(first4) \(middle2)** **** \(lastPart)"
//        }
//        
//        textField.text = formatted
//        return false
//    }
//}
