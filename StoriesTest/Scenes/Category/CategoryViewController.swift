//
//  CategoryViewController.swift
//  StoriesTest
//
//  Created by Kazim Gajiev on 24/07/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
}
