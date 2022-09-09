//
//  ViewController.swift
//  NatifeTest
//
//  Created by Евгений  on 15/07/2022.
//

import UIKit

protocol PostsViewProtocol: AnyObject {
    func didUpdatePosts(posts: [PostsModel])
    func didFailWithError(error: Error)
    func didSorted(posts: [PostsModel])
    func expand(_ postId: Int)
    func collapse(_ postId: Int)
}

final class PostsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var presenter: PostsViewPresenterProtocol!
    private var posts: [PostsModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private var expandedPosts: [Int] = [] {
        didSet {
            tableView.reloadData()
        }
    }
        
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSortButton()
        presenter.viewDidLoad()
        
    }
    
    //MARK: - TableView setup
    private func setupTableView() {
        //        postsTableView.delegate = self
        tableView.dataSource = self
        PostsCell.registerNib(in: self.tableView)
    }
    
    //MARK: - Sorting methods
    private func setupSortButton() {
        sortButton.menu = setSortMenu()
    }
    
    private func setSortMenu() -> UIMenu {
        let sortMenu = UIMenu(title: "Sort by", children: [
            UIAction(title: "Default", image: UIImage(systemName: "stop"))  { action in
                self.presenter.sort(method: .byDefault)
            },
            UIAction(title: "Likes", image: UIImage(systemName: "heart"))  { action in
                self.presenter.sort(method: .byLikes)
            },
            UIAction(title: "Date", image: UIImage(systemName: "calendar")) { action in
                self.presenter.sort(method: .byDate)
            }
        ])
        return sortMenu
    }
}

extension PostsViewController: PostsViewProtocol {
    func didUpdatePosts(posts: [Codable]) {
         
    }
    
    func didSorted(posts: [Codable]) {
         
    }
    
    func didUpdatePosts(posts: [PostsModel]) {
        self.posts = posts
    }
    
    func expand(_ postId: Int) {
        self.expandedPosts.append(postId)
    }
    
    func collapse(_ postId: Int) {
        var postIndex: Int
        if let index = expandedPosts.firstIndex(where: { $0 == postId }) {
            postIndex = Int(index)
            self.expandedPosts.remove(at: postIndex)
        }
    }
    
    func didFailWithError(error: Error) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
    
    func didSorted(posts: [PostsModel]) {
        self.posts = posts
    }
}

//MARK: - UITableViewDataSource
extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostsCell = .cell(in: self.tableView, at: indexPath)
        
        //здесь надо запрашивать у презентера модел для ячейки по индекспасу
        let post = posts[indexPath.row]
        
        cell.configure(post: post)
        
        // передаем ид для ??
        cell.postId = post.postId
        
        // проверка в массиве растянутых ячеек
        if expandedPosts.contains(post.postId) {
            cell.setReadLess()
        } else {
            cell.setReadmore()
        }
        
        //назначеем контроллер делегатом нажатия на кнопку в ячейке
        cell.delegate = self
        return cell
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
