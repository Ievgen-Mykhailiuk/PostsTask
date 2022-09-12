//
//  PostsData.swift
//  NatifeTestTask
//
//  Created by Евгений  on 18/07/2022.
//

import Foundation

struct PostList: Codable {
    let posts: [PostListModel]
}

struct PostListModel: Codable {
    
    let id: Int
    let timeShamp: Double
    let title: String
    let previewText: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case timeShamp = "timeshamp"
        case title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}

struct PostModel: Codable {
    let id: Int
    let timeShamp: Double
    let title: String
    let text: String
    let postImage: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case timeShamp = "timeshamp"
        case title, text, postImage
        case likesCount = "likes_count"
    }
}
