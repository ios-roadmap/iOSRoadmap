//
//  IRMaskInputFieldDelegateTest.swift
//  IRViewsTests
//
//  Created by Ömer Faruk Öztürk on 28.02.2025.
//

import IRViews
import Testing
import UIKit

@Suite
final class IRMaskInputFieldDelegateTest {
    
    var delegate: IRMaskInputFieldDelegate!
    var textField: UITextField!
    
    init() {
        let data = IRMaskInputFieldData(
            input: "1234123412341234",
            mask: .creditCardNumber,
            seperator: .space
        )
        
        self.delegate = IRMaskInputFieldDelegate(data: data)
        self.textField = UITextField()
    }
    
    @Test
    func testShouldChangeCharacters_withEmoji_returnsFalse() {
        let textField = UITextField()
        
        let result = delegate.shouldChangeCharacters(in: textField,
                                                     range: NSRange(location: 0, length: 0),
                                                     with: "😀")
        assert(!result, "shouldChangeCharacters should return false when replacement contains an emoji.")
    }
}
