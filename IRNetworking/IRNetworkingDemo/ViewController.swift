//
//  ViewController.swift
//  IRNetworkingDemo
//
//  Created by Ömer Faruk Öztürk on 18.02.2025.
//

import UIKit
import IRNetworking

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await someRetrieveRequest()
        }
    }

    func someRetrieveRequest() async {
        let retreive = IRNetworkService()
        let result = await retreive.request(IREndpoints.RickAndMorty.character.endpoint, responseType: CharacterResponse.self)
        switch result {
        case .success(let response):
            print(response)
        case .failure(let error):
            print("❌ Request Failed: \(error)")
        }
    }
}

struct CharacterResponse: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
}
