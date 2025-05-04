//
//  StringCasingTest.swift
//  IRFoundationTests
//
//  Created by Ömer Faruk Öztürk on 26.04.2025.
//

import XCTest
@testable import IRFoundation

final class StringCasingTests: XCTestCase {

    func testSnakeCased() {
        XCTAssertEqual("Hello World!".snakeCased(), "hello_world")
        XCTAssertEqual("Snake Cased String".snakeCased(), "snake_cased_string")
        XCTAssertEqual("Already_snake_cased".snakeCased(), "already_snake_cased")
    }

    func testKebabCased() {
        XCTAssertEqual("Hello World!".kebabCased(), "hello-world")
        XCTAssertEqual("Kebab Cased String".kebabCased(), "kebab-cased-string")
        XCTAssertEqual("Already-kebab-cased".kebabCased(), "already-kebab-cased")
    }

    func testCapitalisedFirst() {
        XCTAssertEqual("hello".capitalisedFirst, "Hello")
        XCTAssertEqual("hELLO".capitalisedFirst, "HELLO")
        XCTAssertEqual("".capitalisedFirst, "")
        XCTAssertEqual("123abc".capitalisedFirst, "123abc")
    }
}
