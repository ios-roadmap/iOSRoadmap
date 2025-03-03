//
//  IRMaskFormatterTest.swift
//  IRViewsTests
//
//  Created by Ömer Faruk Öztürk on 28.02.2025.
//

import IRViews
import Testing

// MARK: - FormatterTests Suite
@Suite
final class FormatterTests {
    
    // MARK: - CardFormatter Test
    @Test
    func testCardFormatter() {
        let data = IRMaskInputFieldData(
            input: "1234123412341234",
            mask: .creditCardNumber,
            seperator: .space
        )

        #expect(IRMask.format(data) == "1234 1234 1234 1234")
    }
}
