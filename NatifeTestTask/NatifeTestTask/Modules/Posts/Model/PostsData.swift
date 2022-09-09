//
//  PostsData.swift
//  NatifeTestTask
//
//  Created by Евгений  on 18/07/2022.
//

import Foundation


struct Posts: Codable {
    let posts: [PostsModel]
}
struct PostsModel: Codable {
    
    let postId: Int
    let timeShamp: Double
    let title: String
    let previewText: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case postId
        case timeShamp = "timeshamp"
        case title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}

struct PostModel: Codable {
    let postId: Int
    let timeShamp: Double
    let title: String
    let text: String
    let postImage: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case postId
        case timeShamp = "timeshamp"
        case title, text, postImage
        case likesCount = "likes_count"
    }
}
