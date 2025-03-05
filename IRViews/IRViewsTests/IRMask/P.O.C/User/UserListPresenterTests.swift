//
//  UserListPresenterTests.swift
//  IRViewsTests
//
//  Created by Ömer Faruk Öztürk on 5.03.2025.
//

import XCTest
@testable import IRViewsDemo

class UserListPresenterTests: XCTestCase {
    var presenter: UserListPresenter!
    var mockViewController: MockUserListViewController!

    override func setUp() {
        super.setUp()
        presenter = UserListPresenter()
        mockViewController = MockUserListViewController()
        presenter.viewController = mockViewController
    }

    override func tearDown() {
        presenter = nil
        mockViewController = nil
        super.tearDown()
    }

    func testPresentUsers_ShouldUpdateViewController() {
        // Given
        let users = [User(id: 1, name: "Test User")]

        // When
        presenter.presentUsers(users: users)

        // Then
        XCTAssertTrue(mockViewController.displayUsersCalled)
        XCTAssertEqual(mockViewController.users.count, 1)
    }
}

// MARK: - Mock ViewController
class MockUserListViewController: UserListViewController {
    var displayUsersCalled = false
    override func displayUsers(users: [User]) {
        displayUsersCalled = true
        self.users = users
    }
}
