import UIKit

struct PartialSecuredItem {
    let inputFormat: String
    let emptyCharacter: Character
    let disabledCharacter: Character
    
    init(inputFormat: String, emptyCharacter: Character, disabledCharacter: Character) {
        self.inputFormat = inputFormat
        self.emptyCharacter = emptyCharacter
        self.disabledCharacter = disabledCharacter
    }
}

import Foundation

protocol MaskFormatter {
    /// Verilen ham metni, PartialSecuredItem içindeki kurallara göre formatlar.
    func format(text: String, with item: PartialSecuredItem) -> String
    
    /// Format içerisindeki düzenlenebilir (editable) indexleri döner.
    func allowedInputIndexes(for format: String) -> [Int]
}

import Foundation

class PartialSecuredMaskFormatter: MaskFormatter {
    func format(text: String, with item: PartialSecuredItem) -> String {
        let cleanText = text.filter { $0.isNumber }
        var formattedText = ""
        var digitIndex = 0
        
        for char in item.inputFormat {
            if char == "-" {
                if digitIndex < cleanText.count {
                    let index = cleanText.index(cleanText.startIndex, offsetBy: digitIndex)
                    formattedText.append(cleanText[index])
                    digitIndex += 1
                } else {
                    formattedText.append(item.emptyCharacter)
                }
            } else if char == item.disabledCharacter {
                formattedText.append(item.disabledCharacter)
            } else { 
                formattedText.append(char)
            }
        }
        
        return formattedText
    }
    
    func allowedInputIndexes(for format: String) -> [Int] {
        var indexes: [Int] = []
        for (index, char) in format.enumerated() {
            if char == "-" {
                indexes.append(index)
            }
        }
        return indexes
    }
}

import UIKit

class MaskedCardTextFieldListener: NSObject, UITextFieldDelegate {
    let maskFormatter: MaskFormatter
    let item: PartialSecuredItem
    
    var lastCursorOffset: Int = 0
    
    init(maskFormatter: MaskFormatter, item: PartialSecuredItem) {
        self.maskFormatter = maskFormatter
        self.item = item
    }
    
    // Editing başladığında, cursor’u ilk düzenlenebilir index’e konumlandırır.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tintColor = .clear
        DispatchQueue.main.async {
            let allowedIndexes = self.maskFormatter.allowedInputIndexes(for: self.item.inputFormat)
            if let position = textField.position(from: textField.beginningOfDocument, offset: allowedIndexes.first ?? 0) {
                textField.selectedTextRange = textField.textRange(from: position, to: position)
            }
            textField.tintColor = .label
        }
    }

    // Karakter ekleme/silme işlemlerini ele alır.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        
        if string.isEmpty {
            return handleBackspace(textField, range: range)
        }
        
        // Sadece numerik girişe izin ver
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        // Girdideki rakamları say ve formattaki "-" karakterlerinin sayısıyla sınırla
        let cleanText = currentText.replacingOccurrences(of: " ", with: "").filter { $0.isNumber }
        let maxDigits = self.item.inputFormat.filter { $0 == "-" }.count
        if cleanText.count >= maxDigits {
            return false
        }
        
        // Güncellenmiş metni al ve dışarıdan sağlanan formatter ile formatla
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        textField.text = maskFormatter.format(text: updatedText, with: item)
        
        moveCursorToCorrectPosition(textField, in: range, replacementString: string)
        
        if let position = textField.position(from: textField.beginningOfDocument, offset: lastCursorOffset) {
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
        
        return false
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let position = textField.position(from: textField.beginningOfDocument, offset: lastCursorOffset) {
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
    }
    
    private func handleBackspace(_ textField: UITextField, range: NSRange) -> Bool {
        guard var text = textField.text else { return false }
        
        let cleanText = text.filter { $0.isNumber }
        if cleanText.isEmpty { return false } // Eğer hiç rakam yoksa işlem yapma
        
        // Silinecek en son rakamı bul
        var lastDigitIndex: Int?
        for i in stride(from: text.count - 1, through: 0, by: -1) {
            let index = text.index(text.startIndex, offsetBy: i)
            if text[index].isNumber {
                lastDigitIndex = i
                break
            }
        }
        
        // Eğer hiç rakam yoksa geri çık
        guard let indexToRemove = lastDigitIndex else { return false }
        
        // Metinden rakamı çıkar
        text.remove(at: text.index(text.startIndex, offsetBy: indexToRemove))
        
        // Yeni formatlanmış metni uygula
        textField.text = maskFormatter.format(text: text, with: item)
        
        // İmleci doğru konuma yerleştir
        lastCursorOffset = min(indexToRemove, textField.text?.count ?? 0)
        if let position = textField.position(from: textField.beginningOfDocument, offset: lastCursorOffset) {
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
        
        return false
    }
    
    private func moveCursorToCorrectPosition(_ textField: UITextField, in range: NSRange, replacementString string: String) {
        let formatPattern = item.inputFormat
        let allowedIndexes = maskFormatter.allowedInputIndexes(for: formatPattern)
        var newOffset = range.location + string.count
        
        if string.isEmpty { // Silme işlemi için
            while newOffset > 0 {
                let prevIndex = newOffset - 1
                if allowedIndexes.contains(prevIndex) {
                    break
                }
                newOffset -= 1
            }
        } else { // Ekleme işlemi için
            while newOffset < formatPattern.count {
                if allowedIndexes.contains(newOffset) {
                    break
                }
                newOffset += 1
            }
        }
        
        lastCursorOffset = newOffset
    }
}

import UIKit

class ViewController: UIViewController {
    // Listener'ı property olarak saklayarak güçlü referans tutuyoruz.
    private let listener: MaskedCardTextFieldListener = {
        let partialSecuredItem = PartialSecuredItem(
            inputFormat: "---- --** **** ----",
            emptyCharacter: " ",
            disabledCharacter: "*"
        )
        let formatter = PartialSecuredMaskFormatter()
        return MaskedCardTextFieldListener(maskFormatter: formatter, item: partialSecuredItem)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let cardTextField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        cardTextField.borderStyle = .roundedRect
        cardTextField.keyboardType = .numberPad
        cardTextField.text = listener.maskFormatter.format(text: "", with: listener.item)
        cardTextField.delegate = listener
        
        view.addSubview(cardTextField)
    }
}


//import UIKit
//
//class ViewController: UIViewController, UITextFieldDelegate {
//    
//    private let textField: UITextField = {
//        let tf = UITextField()
//        tf.borderStyle = .roundedRect
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        return tf
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        view.backgroundColor = .white
//        setupTextField()
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
//        
//        textField.delegate = self
//    }
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = textField.text ?? ""
//        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
//        
//        DispatchQueue.main.async {
//            textField.text = newText
//            if let position = textField.position(from: textField.beginningOfDocument, offset: 0) {
//                textField.selectedTextRange = textField.textRange(from: position, to: position)
//            }
//        }
//        
//        return false
//    }
//}
