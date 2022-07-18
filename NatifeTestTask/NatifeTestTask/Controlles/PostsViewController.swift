//
//  ViewController.swift
//  NatifeTestTask
//
//  Created by Евгений  on 18/07/2022.
//

import UIKit

//
//  ViewController.swift
//  NatifeTest
//
//  Created by Евгений  on 15/07/2022.
//

import UIKit

class PostsViewController: UIViewController {
    
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
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(UINib(nibName: "PostsCell", bundle: nil), forCellReuseIdentifier: "reusableCell")
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

extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"reusableCell", for: indexPath) as! PostsCell
        let post = posts[indexPath.row]
        cell.configure(title: post.title, text: post.preview, likes: post.likes, date: post.date)
        cell.onReadMoreTapped = { [weak self] in
            self?.postsTableView.beginUpdates()
            self?.postsTableView.endUpdates()
        }
        return cell
    }
}


extension PostsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}





