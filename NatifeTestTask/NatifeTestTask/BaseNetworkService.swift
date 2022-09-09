//
//  RequestManager.swift
//  NatifeTestTask
//
//  Created by Евгений  on 18/07/2022.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Codable>(from endPoint: EndPoint,
                             httpMethod: BaseNetworkService.HttpMethod,
                             completion: @escaping (Result<T, NetworkError>) -> Void)
}

class BaseNetworkService: NetworkServiceProtocol {
    
    //MARK: - Http methods
    enum HttpMethod: String {
        case get
        case post
        var method: String { rawValue.uppercased() }
    }
 
    //MARK: - Network request method
    func fetch<T: Codable>(from endPoint: EndPoint,
                             httpMethod: HttpMethod = .get,
                             completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        let completionOnMain: (Result<T, NetworkError>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        // configure endPoint
        guard let url = endPoint.url else {
            completionOnMain(.failure(.invalidURL))
            return }
        
        // set http method
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.method
        
        // make request
        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as? NetworkError {
                completionOnMain(.failure(error))
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse else {
                completionOnMain(.failure(.invalidResponse))
                return
            }
            
            if !(200..<300).contains(urlResponse.statusCode) {
                completionOnMain(.failure(.invalidStatusCode))
                return
            }
            
            guard let data = data else {
                completionOnMain(.failure(.noData))
                return
            }
            
            do {
                // decode data to model
                let places = try JSONDecoder().decode(T.self, from: data)
                completionOnMain(.success(places))
            } catch {
                completionOnMain(.failure(.invalidData))
            }
        }
        // start session
        urlSession.resume()
    }
}
