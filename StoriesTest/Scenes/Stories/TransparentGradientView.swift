//
//  GradientView.swift
//  StoriesTest
//
//  Created by Kazim Gajiev on 24/07/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

class TransparentGradientView: UIView {
  
  private var gradientLayer: CAGradientLayer?
  private let colorAlpha: CGFloat = 0.7
  
  @IBInspectable var gradientColor: UIColor? {
    didSet {
      setGradientLayer()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    clipsToBounds = true
    
    backgroundColor = .clear
    gradientLayer = CAGradientLayer()
    setGradientLayer()
  }
  
  private func setGradientLayer() {
    let bottomColor = gradientColor?.withAlphaComponent(colorAlpha).cgColor ?? UIColor.black.withAlphaComponent(colorAlpha).cgColor
    gradientLayer?.colors = [UIColor.clear.cgColor, bottomColor]
    gradientLayer?.frame = bounds
    
    guard let gradientLayer = gradientLayer else { return }
    
    layer.insertSublayer(gradientLayer, at: 0)
  }

}
