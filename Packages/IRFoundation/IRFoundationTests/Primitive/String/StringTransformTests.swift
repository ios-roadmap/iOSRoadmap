//
//  StringTransformTests.swift
//  IRFoundationTests
//
//  Created by Ömer Faruk Öztürk on 26.04.2025.
//

import XCTest
@testable import IRFoundation

final class StringTransformTests: XCTestCase {

    // MARK: - initials

    func test_initials_whenMultipleWords_returnsFirstAndLastInitials() {
        XCTAssertEqual("Ömer Faruk Öztürk".initials.normalised, "ÖÖ")
        XCTAssertEqual("John Doe".initials, "JD")
    }

    func test_initials_whenSingleWord_returnsSameInitialTwice() {
        XCTAssertEqual("Swift".initials, "SS")
    }

    func test_initials_whenEmptyString_returnsEmpty() {
        XCTAssertEqual("".initials, "")
    }

    func test_initials_whenWhitespaceOnly_returnsEmpty() {
        XCTAssertEqual("     ".initials, "")
    }

    // MARK: - trimmed

    func test_trimmed_removesLeadingAndTrailingWhitespaceAndNewlines() {
        XCTAssertEqual("   Hello World  \n".trimmed, "Hello World")
        XCTAssertEqual("\n\nSwift\n".trimmed, "Swift")
    }

    func test_trimmed_whenNoWhitespace_returnsSameString() {
        XCTAssertEqual("Clean".trimmed, "Clean")
    }

    // MARK: - reversedWords

    func test_reversedWords_reversesWordOrder() {
        XCTAssertEqual("swift is fun".reversedWords, "fun is swift")
        XCTAssertEqual("  apple banana  cherry  ".reversedWords, "cherry banana apple")
    }

    func test_reversedWords_whenSingleWord_returnsSameWord() {
        XCTAssertEqual("Swift".reversedWords, "Swift")
    }

    func test_reversedWords_whenEmpty_returnsEmpty() {
        XCTAssertEqual("".reversedWords, "")
    }
}
