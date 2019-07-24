//
//  Storie.swift
//  StoriesTest
//
//  Created by Kazim Gajiev on 19/07/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

struct Stories {
  let mainImage: UIImage // В продакшене должен быть тип String
  let title: String
  var storiesItems: [StoriesItem]
  let categoryLink: String
  var isSeen: Bool
  
  init(mainImage: UIImage, title: String, storiesItems: [StoriesItem], categoryLink: String, isSeen: Bool = false) {
    self.mainImage = mainImage
    self.title = title
    self.storiesItems = storiesItems
    self.categoryLink = categoryLink
    self.isSeen = isSeen
  }
}

struct StoriesItem {
  let storyImage: UIImage // В продакшене должен быть тип String
  let title: String
  let description: String
  var isSeen: Bool
  
  init(storyImage: UIImage, title: String, description: String, isSeen: Bool = false ) {
    self.storyImage = storyImage
    self.title = title
    self.description = description
    self.isSeen = isSeen
  }
}
