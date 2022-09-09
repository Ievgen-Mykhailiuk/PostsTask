//
//  PostsCell.swift
//  NatifeTest
//
//  Created by Евгений  on 15/07/2022.
//

import UIKit

//MARK: - Protocols
protocol CellStateDelegate {
    func buttonPressed(_ postId: Int)
}

final class PostsCell: BaseTableViewCell {
    //MARK: - Outlets
    @IBOutlet private weak var postTitleLabel: UILabel!
    @IBOutlet private weak var postTextLabel: UILabel!
    @IBOutlet private weak var heartImage: UIImageView!
    @IBOutlet private weak var likesLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    //MARK: - Properties
    var delegate: CellStateDelegate?
    var postId = 0
    private let collapsedLines = 2
    private let expandedLines = 0
    private let maxSymbolsCount = 100
    
    //MARK: - Override methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        readMoreButton.isHidden = false
    }
    
    //MARK: - Actions
    @IBAction func ReadMoreButtonPressed(_ sender: UIButton) {
        delegate?.buttonPressed(postId)
    }
    
    //MARK: - View configuration
    func configure (post: PostsModel, isExpanded: Bool) {
        isExpanded ? makeExpanded() : makeCollapsed()
        self.postId = post.postId
        postTitleLabel.text = post.title
        postTextLabel.text = post.previewText
        likesLabel.text = String(post.likesCount)
        configureDate(with: post.timeShamp)
        if  postTextLabel.text!.count < maxSymbolsCount {
            readMoreButton.isHidden = true
        }
    }
    
    //MARK: - Date configuration method
    private func configureDate(with date: Double) {
        let startDate = Date()
        let daysInMonth = 30
        let endDate = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let endDateString = dateFormatter.string(from: endDate)
        if let endDate = dateFormatter.date(from: endDateString) {
            let components = Calendar.current.dateComponents([.day], from: endDate, to: startDate)
            guard let days = components.day else { return }
            if days > daysInMonth {
                dateLabel.text = "\(days/daysInMonth) monthes ago"
            } else {
                dateLabel.text = "\(days) days ago"
            }
        }
    }
    
    //MARK: - Expand/Collaps button setup
    func makeExpanded() {
        self.postTextLabel.numberOfLines = expandedLines
        readMoreButton.setTitle("Read less", for: .normal)
    }
    
    func makeCollapsed() {
        self.postTextLabel.numberOfLines = collapsedLines
        readMoreButton.setTitle("Read more", for: .normal)
    }
    
    private func setupButton() {
        readMoreButton.layer.cornerRadius = 10
        readMoreButton.layer.borderWidth = 1
        readMoreButton.layer.borderColor = UIColor.black.cgColor
        readMoreButton.setTitleColor(.black, for: .normal)
    }
}




