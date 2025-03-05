//
//  UserListInteractor.swift
//  IRViewsDemo
//
//  Created by Ömer Faruk Öztürk on 5.03.2025.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class UserListInteractor {
    var presenter: UserListPresenter?
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchUsers() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                DispatchQueue.main.async {
                    self.presenter?.presentUsers(users: users)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }
        task.resume()
    }
}
