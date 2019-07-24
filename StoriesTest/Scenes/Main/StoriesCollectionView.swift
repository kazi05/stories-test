//
//  StroiresCollectionView.swift
//  StoriesTest
//
//  Created by Kazim Gajiev on 19/07/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

protocol StoriesDelegate: class {
  func storiesSelected(at index: Int, with stories: [Stories], and drame: CGRect)
}

class StoriesCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
  
  //MARK: - Private properties
  
  private var stories: [Stories] = []
  
  //MARK: - Public properties
  
  weak var storiesDelegate: StoriesDelegate?
  
  //MARK: - UIView lifecycle

  override func awakeFromNib() {
    super.awakeFromNib()
    delegate = self
    dataSource = self
    
    contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
  }
  
  //MARK: - Data setting
  
  func set(stories: [Stories]) {
    self.stories = stories
    reloadData()
  }
  
  //MARK: - UICollectionView delegate
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return stories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoriesCollectionViewCell.reuseIdentifier, for: indexPath) as! StoriesCollectionViewCell
    let story = stories[indexPath.row]
    cell.set(stories: story)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let frame = cellForItem(at: indexPath)?.frame else { return }
    storiesDelegate?.storiesSelected(at: indexPath.row, with: stories, and: frame)
  }

}
