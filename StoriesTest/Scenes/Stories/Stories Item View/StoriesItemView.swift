//
//  StoriesItemView.swift
//  StoriesTest
//
//  Created by Kazim Gajiev on 20/07/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

protocol StoriesItemViewDelegate: class {
  func scrollViewScrollToNextStories()
  func scrollViewScrollToPreviousStories()
  func storiesViewControllerPushToCategory()
}

class StoriesItemView: UIView, NibLoadable {

  @IBOutlet weak var storyImage: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var showCategoryButton: UIButton!
  @IBOutlet weak var buttonHeightContraint: NSLayoutConstraint!
  @IBOutlet weak var storiesStrokeView: StoriesStrokeView!
  
  weak var delegate: StoriesItemViewDelegate?
  
  private var storiesItems: [StoriesItem] = []
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
//    clipsToBounds = true
    
    buttonHeightContraint.constant = 0
    showCategoryButton.isHidden = true
    
    storiesStrokeView.delegate = self
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    longPressGesture.minimumPressDuration = 0.3
    addGestureRecognizer(tapGesture)
    addGestureRecognizer(longPressGesture)
  }
  
  @objc private func handleTap(_ tapGesture: UITapGestureRecognizer) {
    let tapPoint = tapGesture.location(in: self).x
    if tapPoint > 100 {
      storiesStrokeView.skip()
    } else {
      storiesStrokeView.rewind()
    }
  }
  
  @objc private func handleLongPress(_ pressGesture: UILongPressGestureRecognizer) {
    if pressGesture.state == .began {
      storiesStrokeView.pauseAnimating()
    } else if pressGesture.state == .ended {
      storiesStrokeView.resumeAnimating()
    }
  }
  
  func set(storiesItems: [StoriesItem]) {
    self.storiesItems = storiesItems
    storyImage.image = storiesItems[0].storyImage
    configureTitleLabel(with: 0)
    configureDescriptionLabel(with: 0)
    storiesStrokeView.reloadData()
  }
  
  private func configureDescriptionLabel(with index: Int) {
    let attributedString = NSMutableAttributedString(string:storiesItems[index].description)
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 10
    
    attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
    attributedString.addAttribute(NSAttributedString.Key.kern, value: 0.5, range: NSRange(location: 0, length: attributedString.length))
    
    descriptionLabel.attributedText = attributedString
  }
  
  private func configureTitleLabel(with index: Int) {
    let attributedString = NSMutableAttributedString(string:storiesItems[index].title.uppercased())
    
    attributedString.addAttribute(NSAttributedString.Key.kern, value: 3.5, range: NSRange(location: 0, length: attributedString.length))
    
    titleLabel.attributedText = attributedString
  }
  
  @IBAction func actionShowCategory(_ sender: Any) {
    delegate?.storiesViewControllerPushToCategory()
  }
  
}

extension StoriesItemView: StoriesStorkeViewDelegate {
  
  //MARK: - StrokeView delegates
  
  func numberOfStrokes() -> Int {
    return storiesItems.count
  }
  
  func strokeViewChangedIndex(index: Int) {
    buttonHeightContraint.constant = index == storiesItems.count - 1 ? 50 : 0
    showCategoryButton.isHidden = index != storiesItems.count - 1
    storyImage.image = storiesItems[index].storyImage
    configureTitleLabel(with: index)
    configureDescriptionLabel(with: index)
  }
  
  func strokeViewFinishedAllAnimations() {
    delegate?.scrollViewScrollToNextStories()
  }
  
  func strokeViewRewindToPreviousStories() {
    delegate?.scrollViewScrollToPreviousStories()
  }
}
