//
//  IRJPHUserListInteractorProtocolSpy.swift
//  IRJPHTests
//
//  Created by Ömer Faruk Öztürk on 10.04.2025.
//

@testable import IRJPH

final class IRJPHUserListInteractorProtocolSpy: IRJPHUserListInteractorProtocol {
    
    private(set) var fetchUsersCalled = false
    
    func fetchUsers() {
        fetchUsersCalled = true
    }
}
