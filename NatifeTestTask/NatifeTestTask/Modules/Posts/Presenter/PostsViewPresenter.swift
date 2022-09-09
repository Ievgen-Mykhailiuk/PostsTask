//
//  PostsViewPresenter.swift
//  NatifeTestTask
//
//  Created by Евгений  on 01/09/2022.
//

import Foundation

protocol PostsViewPresenterProtocol: AnyObject {
    func viewDidLoad()
    func fetchPosts()
    func sort(method: SortMethod)
}

enum SortMethod {
    case byDefault
    case byLikes
    case byDate
}

final class PostsViewPresenter: PostsViewPresenterProtocol {
    
    private weak var view: PostsViewProtocol!
    private let apiManager: ApiManager
    private let router: DefaultPostsRouter
    private var posts = [PostsModel]()
    
    init(view: PostsViewProtocol,
         apiManager: ApiManager,
         router: DefaultPostsRouter) {
        self.view = view
        self.apiManager = apiManager
        self.router = router
    }
    
    func viewDidLoad() {
        apiManager.getPosts { result in
            switch result {
            case .success(let data):
                self.posts = data.posts
                self.view.didUpdatePosts(posts: data.posts)
            case .failure(let error):
                self.view.didFailWithError(error: error)
            }
        }
    }
    
    func fetchPosts() {
        apiManager.getPosts { result in
            switch result {
            case .success(let data):
                self.view.didUpdatePosts(posts: data.posts)
            case .failure(let error):
                self.view.didFailWithError(error: error)
            }
        }
    }
    
    func sort(method: SortMethod) {
        switch method {
        case .byDefault:
            fetchPosts()
        case .byLikes:
            posts =  posts.sorted(by: { $0.likesCount > $1.likesCount } )
            self.view.didSorted(posts: posts)
        case .byDate:
            posts = posts.sorted(by: { $0.timeShamp > $1.timeShamp })
            self.view.didSorted(posts: posts)
        }
    }
}
