//
//  PostsViewController.swift
//  NatifeTest
//
//  Created by Евгений  on 15/07/2022.
//

import UIKit

protocol PostsViewProtocol: AnyObject {
    func updateContent()
    func didFailWithError(error: Error)
}

final class PostsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var sortButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var presenter: PostsViewPresenterProtocol!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: - Private methods
    private func initialSetup() {
        setupTableView()
        setupSortMenu()
        presenter.fetchPosts()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        PostsCell.registerNib(in: self.tableView)
    }
    
    private func setupSortMenu() {
        let sortMenu = UIMenu(title: "Sort by", children: [
            UIAction(title: "Default", image: UIImage(systemName: "stop"))  { action in
                self.presenter.sort(.byDefault)
            },
            UIAction(title: "Likes", image: UIImage(systemName: "heart"))  { action in
                self.presenter.sort(.byLikes)
            },
            UIAction(title: "Date", image: UIImage(systemName: "calendar")) { action in
                self.presenter.sort(.byDate)
            }
        ])
        sortButton.menu = sortMenu
    }
}

extension PostsViewController: PostsViewProtocol {
    func updateContent() {
        tableView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        showAlert(title: "Error", message: error.localizedDescription)
    }
}

//MARK: - UITableViewDataSource
extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getPostsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostsCell = .cell(in: self.tableView, at: indexPath)
        let post = presenter.getPost(by: indexPath.row)
        let state = presenter.isExpanded(post.postId)
        cell.configure(post: post, isExpanded: state)
        cell.delegate = self
        return cell
    }
}

//MARK: - CellStateDelegate
extension PostsViewController: CellStateDelegate {
    func buttonPressed(_ post: Int) {
        presenter.setState(to: post)
    }
}
