//
//  PostsCell.swift
//  NatifeTest
//
//  Created by Евгений  on 15/07/2022.
//

import UIKit

class PostsCell: UITableViewCell {
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var readMoreButton: UIButton!
    
    var onReadMoreTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        readMoreButton.isHidden = false
        readMoreButton.setTitle("Read more", for: .normal)
        postTextLabel.numberOfLines = 2
    }
    
    @IBAction func ReadMoreButtonPressed(_ sender: UIButton) {
        let linesCount = postTextLabel.numberOfLines
        if linesCount == 2 {
            setReadLess()
        }
        if linesCount == 0 {
            setReadmore()
        }
    }
    
    func configureDate(_ date: Double) {
        let startDate = Date()
        let endDate = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let endDateString = dateFormatter.string(from: endDate)
        if let endDate = dateFormatter.date(from: endDateString) {
            let components = Calendar.current.dateComponents([.day], from: endDate, to: startDate)
            if components.day! > 30 {
                dateLabel.text = "\(components.day!/30) monthes ago"
            } else {
                dateLabel.text = "\(components.day!) days ago"
            }
        }
    }
    
    func configure (title: String,
                    text: String,
                    likes: Int,
                    date: Double) {
        postTitleLabel.text = title
        postTextLabel.text = text
        likesLabel.text = String(likes)
        
        if  postTextLabel.text!.count < 100 {
            readMoreButton.isHidden = true
        }
        
        configureDate(date)
    }
    
    private func setReadLess() {
        self.postTextLabel.numberOfLines = 0
        readMoreButton.setTitle("Read less", for: .normal)
        onReadMoreTapped?()
    }
    
    private func setReadmore() {
        self.postTextLabel.numberOfLines = 2
        readMoreButton.setTitle("Read more", for: .normal)
        onReadMoreTapped?()
    }
    
    private func setUpButton() {
        readMoreButton.layer.cornerRadius = 10
        readMoreButton.layer.borderWidth = 1
        readMoreButton.layer.borderColor = UIColor.black.cgColor
        readMoreButton.setTitleColor(.black, for: .normal)
    }
}




