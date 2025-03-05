//
//  UserListRouterTests.swift
//  IRViewsTests
//
//  Created by Ömer Faruk Öztürk on 5.03.2025.
//

import XCTest
@testable import IRViewsDemo

class UserListRouterTests: XCTestCase {
    func testCreateModule_ShouldReturnUserListViewController() {
        // When
        let viewController = UserListRouter.createModule()

        // Then
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is UserListViewController)
    }
}
