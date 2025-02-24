import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Maskeleme yapan özel text field oluştur
        let cardTextField = MaskedCardTextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
        cardTextField.borderStyle = .roundedRect
        cardTextField.placeholder = "Enter card number"
        
        // Ekrana ekle
        view.addSubview(cardTextField)
    }
}

class MaskedCardTextField: UITextField, UITextFieldDelegate {
    
    // Maskeleme formatı: İlk 6 ve Son 4 rakam dışındakiler "*"
    private let visiblePrefixCount = 6
    private let visibleSuffixCount = 4
    private let totalDigits = 16
    private let maskCharacter: Character = "*"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.delegate = self
        self.keyboardType = .numberPad
        self.text = formattedMaskedText("") // Başlangıçta maskeyi uygula
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }
        
        // Eğer silme işlemi ise
        if string.isEmpty {
            return handleBackspace(textField, range: range)
        }
        
        // Yalnızca sayılar girilebilir
        guard CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        
        // Maksimum karakter uzunluğunu kontrol et (boşluklar hariç)
        let cleanText = currentText.replacingOccurrences(of: " ", with: "").filter { $0.isNumber }
        if cleanText.count >= totalDigits {
            return false
        }
        
        // Yeni girişle birlikte güncellenmiş metni al
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        textField.text = formattedMaskedText(updatedText)
        
        // Cursor'ı doğru yere ayarla
        moveCursorToCorrectPosition(textField, in: range, replacementString: string)
        
        return false // Biz manuel olarak değiştirdiğimiz için false döndür
    }
    
    // Silme işlemi özel olarak ele alınmalı
    private func handleBackspace(_ textField: UITextField, range: NSRange) -> Bool {
        guard var text = textField.text else { return false }

        if range.location > 0 {
            var newLocation = range.location - 1
            
            // Boşluk ve yıldız karakterlerini atlayarak ilk rakama ulaş
            while newLocation > 0 {
                let checkIndex = text.index(text.startIndex, offsetBy: newLocation)
                if text[checkIndex].isNumber {
                    break
                }
                newLocation -= 1
            }

            // Eğer yeni konum geçerli değilse çık
            if !text[text.index(text.startIndex, offsetBy: newLocation)].isNumber {
                return false
            }

            // Silinecek karakterin konumu
            let deleteRange = NSRange(location: newLocation, length: 1)
            text.remove(at: text.index(text.startIndex, offsetBy: newLocation))

            textField.text = formattedMaskedText(text)

            // Cursor'un yanlışlıkla fazla sola kaymasını önlemek için +1 ekle
            moveCursorToCorrectPosition(textField, in: NSRange(location: newLocation + 1, length: 0), replacementString: "")

            return false
        }

        return true
    }

    // Yeni metni oluştur ve maskeyi uygula
    private func formattedMaskedText(_ rawText: String) -> String {
        let cleanText = rawText.replacingOccurrences(of: " ", with: "").filter { $0.isNumber }
        
        var formattedText = ""
        var index = 0
        
        for i in 0..<totalDigits {
            if i < visiblePrefixCount || i >= (totalDigits - visibleSuffixCount) {
                // İlk 6 ve son 4 hane → Normal rakam göster
                if index < cleanText.count {
                    formattedText.append(cleanText[cleanText.index(cleanText.startIndex, offsetBy: index)])
                    index += 1
                } else {
                    formattedText.append("_")
                }
            } else {
                // Ara kısımlar → Maskeli göster
                formattedText.append(maskCharacter)
            }
            
            // Boşluk ekleme mantığı (4'erli gruplar)
            if (i + 1) % 4 == 0 && i < totalDigits - 1 {
                formattedText.append(" ")
            }
        }
        
        return formattedText
    }
    
    // Cursor'un doğru pozisyonda kalmasını sağla
    private func moveCursorToCorrectPosition(_ textField: UITextField, in range: NSRange, replacementString string: String) {
        guard let text = textField.text else { return }
        
        var newOffset = range.location + string.count
        let nsText = text as NSString

        if string.isEmpty {
            // Silme işlemi: Cursor'u sola kaydırırken, boşlukları ve yıldızları atla
            while newOffset > 0, let prevChar = nsText.substring(with: NSRange(location: newOffset - 1, length: 1)).first {
                if prevChar == "*" || prevChar == " " {
                    newOffset -= 1
                } else {
                    break
                }
            }
        } else {
            // Ekleme işlemi: Cursor'u sağa kaydırırken, boşlukları ve yıldızları atla
            while newOffset < nsText.length, let nextChar = nsText.substring(with: NSRange(location: newOffset, length: 1)).first {
                if nextChar == "*" || nextChar == " " {
                    newOffset += 1
                } else {
                    break
                }
            }
        }

        if let position = textField.position(from: textField.beginningOfDocument, offset: newOffset) {
            textField.selectedTextRange = textField.textRange(from: position, to: position)
        }
    }

}
