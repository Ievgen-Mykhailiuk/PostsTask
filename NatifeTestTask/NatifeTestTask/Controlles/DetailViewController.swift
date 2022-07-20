//
//  File.swift
//  NatifeTestTask
//
//  Created by Евгений  on 18/07/2022.
//

import UIKit
import Kingfisher

final class DetailViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postLikesCountLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    //MARK: - Properties
    var id = 0
    private var post: [PostsModel] = []
    private var requestManager = RequestManager()
    
    //MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        requestManager.delegate = self
        requestManager.getPostById(id)
    }
    
    //MARK: - Alerts
    private func showAlert(title: String, buttonTitle: String, error: Error) {
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - View configutation
    private func configureScreen(data: [PostsModel]) {
        guard let model = data.first else { return }
        let path = model.link
        guard let url = URL(string: path!) else { return }
        DispatchQueue.main.async {
            self.postTitleLabel.text = model.title
            self.postImageView.kf.setImage(with: url)
            self.postTextLabel.text = model.preview
            self.postLikesCountLabel.text = String(model.likes)
            self.postDateLabel.text = self.formatDate(model.date)
        }
    }
    
    //MARK: - Date configuration
    private func formatDate(_ date: Double) -> String {
        let postDate = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "dd  MMMM  yyyy"
        let postDateString = dateFormatter.string(from: postDate)
        return postDateString
    }
}

//MARK: - RequestManagerDelegate
extension DetailViewController: RequestManagerDelegate {
    func updateContent(data: [PostsModel]) {
        configureScreen(data: data)
    }
    
    func didFailWithError(error: Error) {
        showAlert(title: "Error", buttonTitle: "OK", error: error)
    }
}
