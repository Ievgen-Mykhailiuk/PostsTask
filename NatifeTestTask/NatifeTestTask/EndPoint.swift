//
//  EndPoint.swift
//  NatifeTestTask
//
//  Created by Евгений  on 08/09/2022.
//

import Foundation

enum EndPoint {
    case getPosts
    case getPost(id: Int)
}

extension EndPoint {
    
    var domainComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "raw.githubusercontent.com"
        components.path = path
        return components
    }
    
    var path: String {
        switch self {
        case .getPosts:
            return "/anton-natife/jsons/master/api/main.json"
        case .getPost(let id):
            return "/anton-natife/jsons/master/api/posts/\(id).json"
        }
    }
    
    var url: URL? {
        let components = domainComponents
        return components.url
    }
}
