//
//  UserListViewControllerTests.swift
//  IRViewsTests
//
//  Created by Ömer Faruk Öztürk on 5.03.2025.
//

import XCTest
@testable import IRViewsDemo

class UserListViewControllerTests: XCTestCase {
    var viewController: UserListViewController!
    var mockInteractor: MockUserListInteractor!

    override func setUp() {
        super.setUp()
        viewController = UserListViewController()
        mockInteractor = MockUserListInteractor()
        viewController.interactor = mockInteractor
    }

    override func tearDown() {
        viewController = nil
        mockInteractor = nil
        super.tearDown()
    }

    func testViewDidLoad_ShouldFetchUsers() {
        // When
        viewController.viewDidLoad()

        // Then
        XCTAssertTrue(mockInteractor.fetchUsersCalled)
    }
}

// MARK: - Mock Interactor
class MockUserListInteractor: UserListInteractor {
    var fetchUsersCalled = false

    override func fetchUsers() {
        fetchUsersCalled = true
    }
}
