//
//  StoriesViewController.swift
//  StoriesTest
//
//  Created by Kazim Gajiev on 20/07/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

class StoriesViewController: UIViewController {
  
  //MARK: - Outlets
  
  @IBOutlet weak var backgorundView: UIView!
  @IBOutlet weak var transformedView: UIView!
  @IBOutlet weak var storiesScrollView: StoriesScrollView!
  
  //MARK: - Public properties
  
  var stories: [Stories] = []
  var storiesItemViewIndex = 0
  
  //MARK: - Private properties
  
  private var currentSelectedStoriesItemView = 0
  
  //MARK: - UIViewController lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .clear
    
    transformedView.clipsToBounds = true
    
    storiesScrollView.isDirectionalLockEnabled = true
    storiesScrollView.viewController = self
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanDown(_:)))
    view.addGestureRecognizer(panGesture)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    UIApplication.shared.isStatusBarHidden = true
    
    if !isMovingToParent {
      storiesScrollView.startAnimateSelectedStoriesItemView(at: currentSelectedStoriesItemView)
    }
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if isMovingToParent {
      storiesScrollView.setDataSource(with: stories)
      storiesScrollView.startAnimateSelectedStoriesItemView(at: storiesItemViewIndex)
      currentSelectedStoriesItemView = storiesItemViewIndex
      
      storiesScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.maxX * CGFloat(storiesItemViewIndex), y: 0)
      storiesScrollView.delegate = self
    }
    
    createCancelButton()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    UIApplication.shared.isStatusBarHidden = false
    storiesScrollView.stopAnimateSelectedStoriesItemView(at: currentSelectedStoriesItemView)
  }
  
  //MARK: - Decoration
  
  private func createCancelButton() {
    let width: CGFloat = 25
    let height: CGFloat = 25
    let button = UIButton(frame: CGRect(x: transformedView.bounds.width - width * 2, y: transformedView.bounds.minY + height, width: width, height: height))
    button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
    button.addTarget(self, action: #selector(actionCancel(_:)), for: .touchUpInside)
    transformedView.addSubview(button)
  }
  
  //MARK: - Actions
  
  @objc private func handlePanDown(_ panGesture: UIPanGestureRecognizer) {
    let yPos = panGesture.translation(in: self.view).y.rounded()
    let alpha = 1 - (yPos / 2000)
    let newTransform = 1 - (yPos / 3000)
    
    transformedView.frame.origin.y = yPos > 0 ? yPos : 0
    transformedView.transform = CGAffineTransform(scaleX: newTransform > 0.95 ? newTransform : 0.95, y: 1)
    
    storiesScrollView.layoutSubviews()
    storiesScrollView.pauseAnimateSelectedStoriesItemView(at: currentSelectedStoriesItemView)
    storiesScrollView.transform = CGAffineTransform(scaleX: 1 + (1 - newTransform), y: 1)
    
    backgorundView.alpha = alpha > 0.7 ? alpha : 0.7
    
    if panGesture.state == .ended {
      if yPos < 150 {
        UIView.animate(withDuration: 0.3) {
          self.transformedView.transform = CGAffineTransform.identity
          self.transformedView.frame.origin.y = 0
          self.storiesScrollView.resumeAnimateSelectedStoriesItemView(at: self.currentSelectedStoriesItemView)
          self.backgorundView.alpha = 1
        }
      }else {
        backgorundView.alpha = 0
        self.dismiss(animated: true, completion: nil)
      }
    }
    
  }
  
  @objc private func actionCancel(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}

extension StoriesViewController: UIScrollViewDelegate {
  
  //MARK: - UIScrollViewDelegate
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
      scrollView.contentOffset.y = 0
    }
    let visibleViews = storiesScrollView.visibleViews().sorted(by: {$0.frame.origin.x > $1.frame.origin.x} )
    let xOffset = scrollView.contentOffset.x // 2
    
    storiesScrollView.pauseAnimateSelectedStoriesItemView(at: currentSelectedStoriesItemView)
    storiesScrollView.disableStoriesItemViewsTapGesture()
    
    let rightViewAnchorPoint = CGPoint(x: 0, y: 0.5)
    let leftViewAnchorPoint = CGPoint(x: 1, y: 0.5)
    
    var transform = CATransform3DIdentity
    transform.m34 = 1.0 / 1000
    
    let leftSideOriginalTransform = CGFloat(90 * Double.pi / 180.0)
    let rightSideCellOriginalTransform = -CGFloat(90 * Double.pi / 180.0)
    
    if let viewFurthestRight = visibleViews.first, let viewFurthestLeft =  visibleViews.last {
      let hasCompletedPaging = (xOffset / scrollView.frame.width).truncatingRemainder(dividingBy: 1) == 0
      
      if hasCompletedPaging {
        let newIndex = storiesScrollView.currentViewIndex()
        storiesScrollView.enableStoriesItemViewTapGesture(at: newIndex)
        if newIndex != currentSelectedStoriesItemView {
          storiesScrollView.stopAnimateSelectedStoriesItemView(at: currentSelectedStoriesItemView)
          storiesScrollView.startAnimateSelectedStoriesItemView(at: newIndex)
        } else {
          storiesScrollView.resumeAnimateSelectedStoriesItemView(at: currentSelectedStoriesItemView)
        }
        
        currentSelectedStoriesItemView = newIndex
      }
      
      var rightAnimationPercentComplete = hasCompletedPaging ? 0 : 1 - (xOffset / scrollView.frame.width).truncatingRemainder(dividingBy: 1)
      
      if xOffset < 0 { rightAnimationPercentComplete -= 1 }
      viewFurthestRight.transform(to: rightSideCellOriginalTransform * rightAnimationPercentComplete, with: transform)
      viewFurthestRight.setAnchorPoint(rightViewAnchorPoint)
      
      if  xOffset > 0 {
        let leftAnimationPercentComplete = (xOffset / scrollView.frame.width).truncatingRemainder(dividingBy: 1)
        viewFurthestLeft.transform(to: leftSideOriginalTransform * leftAnimationPercentComplete, with: transform)
        viewFurthestLeft.setAnchorPoint(leftViewAnchorPoint)
      }
    }
  }
}
