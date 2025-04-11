//
//  IRJPHUserListInteractorOutputSpy.swift
//  IRJPHTests
//
//  Created by Ömer Faruk Öztürk on 10.04.2025.
//

import IRNetworking
@testable import IRJPH

final class IRJPHUserListInteractorOutputSpy: IRJPHUserListInteractorOutput {

    private(set) var usersFetchedCalled = false
    private(set) var usersFetchedParam: [IRJPHUser]?
    
    private(set) var usersFetchFailedCalled = false
    private(set) var usersFetchFailedParam: Error?
    
    func usersFetched(_ response: [IRJPHUser]) {
        usersFetchedCalled = true
        usersFetchedParam = response
    }
    
    func usersFetchFailed(_ error: Error) {
        usersFetchFailedCalled = true
        usersFetchFailedParam = error
    }
}
