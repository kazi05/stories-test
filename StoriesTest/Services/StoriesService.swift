//
//  StoriesService.swift
//  StoriesTest
//
//  Created by Kazim Gajiev on 19/07/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import Foundation

protocol StoriesService {
  func fetchStories(completion: @escaping ([Stories]) -> Void)
}


