//
//  PostsViewPresenter.swift
//  NatifeTestTask
//
//  Created by Евгений  on 01/09/2022.
//

import Foundation

protocol PostsViewPresenterProtocol: AnyObject {
    func fetchPosts()
    func sort(_ method: SortingMethod)
    func getPost(by index: Int) -> PostsModel
    func getPostsCount() -> Int
    func isExpanded(_ postId: Int) -> Bool
    func setState(to post: Int)
}

enum SortingMethod {
    case byDefault
    case byLikes
    case byDate
}

final class PostsViewPresenter {
    
    //MARK: - Properties
    private weak var view: PostsViewProtocol!
    private let apiManager: PostsAPIService
    private let router: DefaultPostsRouter
    private var posts = [PostsModel]() {
        didSet {
            self.view.updateContent()
        }
    }
    private var expandedPosts = [Int]() {
        didSet {
            self.view.updateContent()
        }
    }
    
    //MARK: - Life Cycle
    init(view: PostsViewProtocol,
         apiManager: PostsAPIService,
         router: DefaultPostsRouter) {
        self.view = view
        self.apiManager = apiManager
        self.router = router
    }
}

//MARK: - PostsViewPresenterProtocol
extension PostsViewPresenter: PostsViewPresenterProtocol {
    func fetchPosts() {
        apiManager.getPosts { result in
            switch result {
            case .success(let data):
                self.posts = data.posts
            case .failure(let error):
                self.view.didFailWithError(error: error)
            }
        }
    }
    
    func sort(_ method: SortingMethod) {
        switch method {
        case .byDefault:
            fetchPosts()
        case .byLikes:
            posts =  posts.sorted(by: { $0.likesCount > $1.likesCount })
        case .byDate:
            posts = posts.sorted(by: { $0.timeShamp > $1.timeShamp })
        }
    }
    
    func getPost(by index: Int) -> PostsModel {
        return posts[index]
    }
    
    func getPostsCount() -> Int {
        return posts.count
    }
    
    func isExpanded(_ postId: Int) -> Bool {
        var state: Bool
        if expandedPosts.contains(postId) {
            state = true
        } else {
            state = false
        }
        return state
    }
    
    func setState(to post: Int) {
        if expandedPosts.contains(post) {
            var postIndex: Int
            if let index = expandedPosts.firstIndex(where: { $0 == post }) {
                postIndex = Int(index)
                expandedPosts.remove(at: postIndex)
            }
        } else {
            expandedPosts.append(post)
        }
    }
}

