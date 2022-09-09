//
//  DefaultPostsAssembly.swift
//  NatifeTestTask
//
//  Created by Евгений  on 01/09/2022.
//

import UIKit

protocol PostsAssembly {
    func createPostsModule() -> UIViewController
}

final class DefaultPostsAssembly: PostsAssembly {
    func createPostsModule() -> UIViewController {
        let view  = PostsViewController.instantiateFromStoryboard()
        let apiManager = PostsAPIService()
        let router = DefaultPostsRouter(viewController: view)
        let presenter = PostsViewPresenter(view: view,
                                           apiManager: apiManager,
                                           router: router)
        view.presenter = presenter
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
}
