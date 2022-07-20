//
//  ViewController.swift
//  NatifeTest
//
//  Created by Евгений  on 15/07/2022.
//

import UIKit

final class PostsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var postsTableView: UITableView!
    
    //MARK: - Properties
    private var requestManager = RequestManager()
    private var posts: [PostsModel] = [] {
        didSet {
            postsTableView.reloadData()
        }
    }
    private var expandedPosts: [Int] = [] {
        didSet {
            postsTableView.reloadData()
        }
    }
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        requestManager.delegate = self
        setupSortButton()
        requestManager.getPosts()
    }
    
    //MARK: - TableView setup
    private func setupTableView() {
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(UINib(nibName: "PostsCell", bundle: nil), forCellReuseIdentifier: "reusableCell")
    }
    
    //MARK: - Alerts
    private func showAlert(title: String, buttonTitle: String, error: Error) {
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Sorting methods
    private func setupSortButton() {
        sortButton.menu = sortMenu()
    }
    
    private func sortMenu() -> UIMenu {
        let sortMenu = UIMenu(title: "Sort by", children: [
            UIAction(title: "Default", image: UIImage(systemName: "stop"))  { action in
                self.requestManager.getPosts()
            },
            UIAction(title: "Likes", image: UIImage(systemName: "heart"))  { action in
                self.sortByLikes()
            },
            UIAction(title: "Date", image: UIImage(systemName: "calendar")) { action in
                self.sortByDate()
            }
        ])
        return sortMenu
    }
    
    private func sortByLikes() {
        posts =  posts.sorted(by: { $0.likes > $1.likes} )
        postsTableView.reloadData()
    }
    
    private func sortByDate() {
        posts = posts.sorted(by: { $0.date > $1.date})
        postsTableView.reloadData()
    }
}

//MARK: - RequestManagerDelegate
extension PostsViewController: RequestManagerDelegate {
    func updateContent(data: [PostsModel]) {
        DispatchQueue.main.async {
            self.posts = data
        }
    }
    
    func didFailWithError(error: Error) {
        showAlert(title: "Error", buttonTitle: "OK", error: error)
    }
}

//MARK: - UITableViewDataSource
extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"reusableCell", for: indexPath) as! PostsCell
        let post = posts[indexPath.row]
        cell.configure(title: post.title, text: post.preview, likes: post.likes, date: post.date)
        cell.postId = post.id
        
        if expandedPosts.contains(post.id) {
            cell.setReadLess()
        } else {
            cell.setReadmore()
        }

        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDelegate
extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postId = posts[indexPath.row].id
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailViewController
        vc.id = postId
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - CellStateDelegate
extension PostsViewController: CellStateDelegate {
    func cellIsExpanded(_ postId: Int) {
        expandedPosts.append(postId)
    }
    
    func cellIsCollapsed(_ postId: Int) {
        var postIndex: Int
        if let index = expandedPosts.firstIndex(where: { $0 == postId }) {
            postIndex = Int(index)
            expandedPosts.remove(at: postIndex)
        }
    }
}


