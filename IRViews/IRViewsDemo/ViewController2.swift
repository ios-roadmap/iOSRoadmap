//import UIKit
//
//class ViewController: UIViewController, UITextFieldDelegate {
//    
//    private let textField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Enter text"
//        tf.borderStyle = .roundedRect
//        tf.text = String(repeating: " ", count: 20) // 20 karakterlik boşluk
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.tintColor = .clear
//        return tf
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupTextField()
//        textField.addTarget(self, action: #selector(moveCursorToBeginning), for: .editingDidBegin)
//    }
//    
//    @objc private func moveCursorToBeginning() {
//        DispatchQueue.main.async {
//            if let startPosition = self.textField.position(from: self.textField.beginningOfDocument, offset: 0) {
//                self.textField.selectedTextRange = self.textField.textRange(from: startPosition, to: startPosition)
//            }
//            self.textField.tintColor = .tintColor
//        }
//    }
//    
//    private func setupTextField() {
//        view.addSubview(textField)
//        
//        NSLayoutConstraint.activate([
//            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            textField.widthAnchor.constraint(equalToConstant: 250),
//            textField.heightAnchor.constraint(equalToConstant: 40)
//        ])
//    }
//}
