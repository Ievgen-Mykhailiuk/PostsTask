//
//  ViewController.swift
//  NatifeTestTask
//
//  Created by Евгений  on 18/07/2022.
//

import UIKit

class PostsViewController: UIViewController {
    
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var postsTableView: UITableView!
    
    var requestManager = RequestManager()
    var posts: [PostsModel] = [] {
        didSet {
            postsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "PostsApp"
        requestManager.delegate = self
        requestManager.getURL()
    }
}

extension PostsViewController: RequestManagerDelegate {
    func updateContent(data: [PostsModel]) {
        DispatchQueue.main.async {
            self.posts = data
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


