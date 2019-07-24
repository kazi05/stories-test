//
//  StoriesScrollView.swift
//  StoriesTest
//
//  Created by Kazim Gajiev on 20/07/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

class StoriesScrollView: UIScrollView {
  
  //MARK: - Public properties
  
  weak var viewController: StoriesViewController?
  var storiesItemViews: [StoriesItemView] = []
  
  //MARK: - Private properties
  
  private var stories: [Stories] = []
  
  //MARK: - Setting data
  
  func setDataSource(with stories: [Stories]) {
    self.stories = stories
    for i in 0..<stories.count {
      let storiesItemView = StoriesItemView.loadFromNib()
      let width = bounds.width
      let height = bounds.height
      let xOffset = width * CGFloat(i)
      storiesItemView.frame = CGRect(x: xOffset, y: 0, width: width, height: height)
      storiesItemView.set(storiesItems: stories[i].storiesItems)
      storiesItemView.delegate = self
      storiesItemViews.append(storiesItemView)
      addSubview(storiesItemView)
      contentSize = CGSize(width: xOffset + width, height: height)
    }
  }
  
  //MARK: - Animation actions
  
  func startAnimateSelectedStoriesItemView(at index: Int) {
    storiesItemViews[index].layoutIfNeeded()
    storiesItemViews[index].storiesStrokeView.startAnimating()
  }

  func stopAnimateSelectedStoriesItemView(at index: Int) {
    storiesItemViews[index].storiesStrokeView.stopAnimating()
  }

  func pauseAnimateSelectedStoriesItemView(at index: Int) {
    storiesItemViews[index].storiesStrokeView.pauseAnimating(hide: false)
  }

  func resumeAnimateSelectedStoriesItemView(at index: Int) {
    storiesItemViews[index].storiesStrokeView.resumeAnimating()
  }
  
  //MARK: - Stories Item View actions
  
  func enableStoriesItemViewTapGesture(at index: Int) {
    storiesItemViews[index].isUserInteractionEnabled = true
  }
  
  func disableStoriesItemViewsTapGesture() {
    storiesItemViews.forEach { $0.isUserInteractionEnabled = false }
  }
  
  //MARK: - Array indexes
  
  func currentViewIndex() -> Int {
    let visibleRect = CGRect(x: contentOffset.x, y: 0, width: frame.width, height: frame.height)
    for (index, view) in storiesItemViews.enumerated() {
      if view.frame.intersects(visibleRect) { return index }
    }
    return 0
  }
  
  func visibleViews() -> [StoriesItemView] {
    let visibleRect = CGRect(x: contentOffset.x, y: 0, width: frame.width, height: frame.height)
    var views = [StoriesItemView]()
    for view  in storiesItemViews{
      if view.frame.intersects(visibleRect) { views.append(view) }
    }
    return views
  }
  
}

extension StoriesScrollView: StoriesItemViewDelegate {
  
  //MARK: - StoriesItemViewDelegate
  
  func scrollViewScrollToNextStories() {
    disableStoriesItemViewsTapGesture()
    let currentIndex = currentViewIndex()
    if currentIndex < storiesItemViews.count - 1 {
      let screenSize = UIScreen.main.bounds.maxX
      let point = CGPoint(x: CGFloat(currentIndex + 1) * screenSize, y: 0)
      setContentOffset(point, animated: true)
    } else {
      viewController?.dismiss(animated: true, completion: nil)
    }
  }
  
  func scrollViewScrollToPreviousStories() {
    disableStoriesItemViewsTapGesture()
    let currentIndex = currentViewIndex()
    if currentIndex > 0 {
      let screenSize = UIScreen.main.bounds.maxX
      let point = CGPoint(x: CGFloat(currentIndex - 1) * screenSize, y: 0)
      setContentOffset(point, animated: true)
    }
  }
  
  func storiesViewControllerPushToCategory() {
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let categoryVC = sb.instantiateViewController(withIdentifier: "CategoryVC")
    categoryVC.title = stories[currentViewIndex()].categoryLink
    viewController?.navigationController?.pushViewController(categoryVC, animated: true)
  }
  
}
