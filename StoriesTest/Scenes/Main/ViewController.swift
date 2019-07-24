//
//  ViewController.swift
//  StoriesTest
//
//  Created by Kazim Gajiev on 19/07/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StoriesDelegate {
  
  //MARK: - Outlets

  @IBOutlet weak var storiesCollectionView: StoriesCollectionView!
  
  let storiesService: StoriesService = StoriesServiceImplementation()
  
  //MARK: - UIViewController ligfecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    storiesCollectionView.storiesDelegate = self
    
    storiesService.fetchStories { [weak self] (stories) in
      self?.storiesCollectionView.set(stories: stories)
    }
  }
  
  //MARK: - Stories delegate
  
  func storiesSelected(at index: Int, with stories: [Stories], and frame: CGRect) {
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let storiesViewController = sb.instantiateViewController(withIdentifier: "StoriesViewController") as! StoriesViewController
    storiesViewController.stories = stories
    storiesViewController.storiesItemViewIndex = index
    let nc = UINavigationController(rootViewController: storiesViewController)
    nc.modalPresentationStyle = .overCurrentContext
    present(nc, animated: true, completion: nil)
  }

}

