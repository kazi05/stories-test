//
//  StorieCollectionViewCell.swift
//  StoriesTest
//
//  Created by Kazim Gajiev on 19/07/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

class StoriesCollectionViewCell: UICollectionViewCell {
  
  static let reuseIdentifier = "StoryCell"
  
  //MARK: - Outlets
  
  @IBOutlet weak var storyImage: UIImageView!
  @IBOutlet weak var storyTitle: UILabel!
  
  //MARK: - UIView lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    storyImage.layer.cornerRadius = storyImage.frame.width / 2
    storyImage.clipsToBounds = true
    
    storyImage.layer.borderColor = UIColor.white.cgColor
    storyImage.layer.borderWidth = 4
    
    let overlayView = UIView(frame: storyImage.frame)
    overlayView.backgroundColor = .clear
    overlayView.layer.cornerRadius = storyImage.frame.width / 2
    overlayView.clipsToBounds = true
    overlayView.layer.borderColor = UIColor.black.cgColor
    overlayView.layer.borderWidth = 2
    addSubview(overlayView)
    
  }
  
  //MARK: - Data source
  
  func set(stories: Stories) {
    storyImage.image = stories.mainImage
    storyTitle.text = stories.title
  }
  
}
