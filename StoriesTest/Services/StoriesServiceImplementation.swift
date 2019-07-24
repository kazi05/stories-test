//
//  StoriesServiceImplementation.swift
//  StoriesTest
//
//  Created by Kazim Gajiev on 19/07/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import Foundation

class StoriesServiceImplementation: StoriesService {
  
  private let storiesPlaceholder: [Stories] = [
    
    Stories(mainImage: #imageLiteral(resourceName: "image.png"), title: "Бренды", storiesItems: [
        StoriesItem(storyImage: #imageLiteral(resourceName: "image.png"), title: "Giorgio Armani", description: "Волна шока рождается в сердце и, вибрируя, затрагивает все новые и новые струны души, пробуждая неведомые ранее чувства. Яркий и свежий аромат Black Opium Floral Shock подобен взрыву цветочных нот, он дарит прохладу, как утренняя роса, и бодрит, как первый глоток эспрессо после пробуждения. Всплеск чувственности."),
        StoriesItem(storyImage: #imageLiteral(resourceName: "1dc0ea67c825bcc819f83542b5d73c11d85e4b0e.png"), title: "Giorgio Armani", description: "Волна шока рождается в сердце и, вибрируя, затрагивает все новые и новые струны души, пробуждая неведомые ранее чувства. Я"),
        StoriesItem(storyImage: #imageLiteral(resourceName: "3ca5b359c3b8b251869e5d76ca50fe21e097860c.png"),title: "Giorgio Armani", description: "Яркий и свежий аромат Black Opium Floral Shock подобен взрыву цветочных нот, он дарит прохладу, как утренняя роса, и бодрит, как первый глоток эспрессо после пробуждения. Всплеск чувственности."),
        StoriesItem(storyImage: #imageLiteral(resourceName: "06d9eafced1eb529956b5700f54ce1c4159a192a.png"), title: "Giorgio Armani", description: "Волна шока рождается в сердце и, вибрируя, затрагивает все новые и новые струны души.")
      ], categoryLink: "Бренды"),
    
    Stories(mainImage: #imageLiteral(resourceName: "42932f3f7516dc386aa7f9f8be886c1b8c2a9383.png"), title: "Новинки", storiesItems: [
      StoriesItem(storyImage: #imageLiteral(resourceName: "752a04da9485a90910efeb5bdd5464277a5f9a4e"), title: "Giorgio Armani", description: "Волна шока рождается в сердце и, вибрируя, затрагивает все новые и новые струны души, пробуждая неведомые ранее чувства. Я"),
      StoriesItem(storyImage: #imageLiteral(resourceName: "1dc0ea67c825bcc819f83542b5d73c11d85e4b0e"),title: "Giorgio Armani", description: "Яркий и свежий аромат Black Opium Floral Shock подобен взрыву цветочных нот, он дарит прохладу, как утренняя роса, и бодрит, как первый глоток эспрессо после пробуждения. Всплеск чувственности."),
      StoriesItem(storyImage: #imageLiteral(resourceName: "a3f8fe4a19c9480e65fb280f0b04866c3d60cd3f"), title: "Giorgio Armani", description: "Волна шока рождается в сердце и, вибрируя, затрагивает все новые и новые струны души.")
      ], categoryLink: "Новинки"),
    
    Stories(mainImage: #imageLiteral(resourceName: "a3f8fe4a19c9480e65fb280f0b04866c3d60cd3f"), title: "Korea", storiesItems: [
      StoriesItem(storyImage: #imageLiteral(resourceName: "813946a6d6ea17cfe5efce8000458d7a9473b5aa"), title: "Giorgio Armani", description: "Волна шока рождается в сердце и, вибрируя, затрагивает все новые и новые струны души, пробуждая неведомые ранее чувства. Я"),
      StoriesItem(storyImage: #imageLiteral(resourceName: "ea03d5c9860274f7fd3dab994ccc27aa8298ac2e"),title: "Giorgio Armani", description: "Яркий и свежий аромат Black Opium Floral Shock подобен взрыву цветочных нот, он дарит прохладу, как утренняя роса, и бодрит, как первый глоток эспрессо после пробуждения. Всплеск чувственности."),
      StoriesItem(storyImage: #imageLiteral(resourceName: "0f2c33fb690aabb5a045c8c339528c20652880a6"), title: "Giorgio Armani", description: "Волна шока рождается в сердце и, вибрируя, затрагивает все новые и новые струны души.")
      ], categoryLink: "Korea")
    
  ]
  
  func fetchStories(completion: @escaping ([Stories]) -> Void) {
    completion(self.storiesPlaceholder)
  }
  
}
