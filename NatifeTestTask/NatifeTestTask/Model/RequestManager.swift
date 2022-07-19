//
//  RequestManager.swift
//  NatifeTestTask
//
//  Created by Евгений  on 18/07/2022.
//

import Foundation

//MARK: - Protocols
protocol RequestManagerDelegate: AnyObject {
    func updateContent (data: [PostsModel])
    func didFailWithError(error: Error)
}

final class RequestManager {
    //MARK: - Properties
    weak var delegate: RequestManagerDelegate?
    let baseURL = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json"
    
    //MARK: - Request methods
    func getPosts() {
        if let readyURL = URL(string: baseURL) {
            performRequest(url: readyURL)
        }
    }
    
    func getPostById(_ postId: Int) {
        let path = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/\(postId).json"
        if let readyURL = URL(string: path) {
            performRequest(url: readyURL)
        }
    }
    
    //MARK: - URLSession method
    private func performRequest(url: URL) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            if let safeData = data {
                self.parseJSON(data: safeData)
            }
        }
        task.resume()
    }
    
    //MARK: - Parse JSON method
    private func parseJSON (data: Data) {
        let decoder = JSONDecoder()
        var postsArray: [PostsModel] = []
        do {
            let postsData = try decoder.decode(PostsData?.self, from: data)
            guard let  decodedData = postsData else {return}
            if let posts = decodedData.posts {
                for post in posts {
                    let model = PostsModel(id: post.postId,
                                           date: post.timeShamp,
                                           title: post.title,
                                           preview: post.previewText,
                                           likes: post.likesCount,
                                           link: nil)
                    postsArray.append(model)
                }
                self.delegate?.updateContent(data: postsArray)
            }
            if let post = decodedData.post {
                let model = PostsModel(id: post.postId,
                                       date: post.timeShamp,
                                       title: post.title,
                                       preview: post.text,
                                       likes: post.likesCount,
                                       link: post.postImage)
                postsArray.append(model)
                self.delegate?.updateContent(data: postsArray)
            }
        } catch {
            self.delegate?.didFailWithError(error: error)
        }
    }
}
