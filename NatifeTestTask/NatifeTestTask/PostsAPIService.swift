//
//  ApiManager.swift
//  NatifeTestTask
//
//  Created by Евгений  on 08/09/2022.
//

import Foundation

protocol PostsNetworkService {
    func getPosts(completion: @escaping (Result<Posts, NetworkError>) -> Void)
}

class PostsAPIService: BaseNetworkService, PostsNetworkService {

    func getPosts(completion: @escaping (Result<Posts, NetworkError>) -> Void) {
        fetch(from: .getPosts,
                httpMethod: .get) { (result: Result<Posts, NetworkError>) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
