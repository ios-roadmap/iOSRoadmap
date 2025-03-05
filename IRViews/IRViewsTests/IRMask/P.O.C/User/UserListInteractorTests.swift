//
//  UserListInteractorTests.swift
//  IRViewsTests
//
//  Created by Ömer Faruk Öztürk on 5.03.2025.
//

import XCTest
@testable import IRViewsDemo

class UserListInteractorTests: XCTestCase {
    var interactor: UserListInteractor!
    var mockPresenter: MockUserListPresenter!
    var mockURLSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockPresenter = MockUserListPresenter()
        mockURLSession = MockURLSession()
        interactor = UserListInteractor(session: mockURLSession)
        interactor.presenter = mockPresenter
    }

    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockURLSession = nil
        super.tearDown()
    }

    func testFetchUsers_ShouldCallPresenterWithUsers() {
        let jsonData = """
        [
            { "id": 1, "name": "John Doe" },
            { "id": 2, "name": "Jane Doe" }
        ]
        """.data(using: .utf8)!

        mockURLSession.mockData = jsonData
        let expectation = expectation(description: "Presenter'a kullanıcı listesi gelmeli")

        interactor.fetchUsers()

        DispatchQueue.main.async {
            XCTAssertTrue(self.mockPresenter.presentUsersCalled)
            XCTAssertEqual(self.mockPresenter.users.count, 2)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Presenter
class MockUserListPresenter: UserListPresenter {
    var presentUsersCalled = false
    var users: [User] = []

    override func presentUsers(users: [User]) {
        presentUsersCalled = true
        self.users = users
    }
}

// MARK: - Mock URLSession
class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(mockData, nil, nil)
        return URLSessionDataTaskMock()
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    override func resume() {}
}
