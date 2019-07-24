//
//  StoriesStorkeView.swift
//  StoriesTest
//
//  Created by Kazim Gajiev on 20/07/2019.
//  Copyright © 2019 Kazim Gajiev. All rights reserved.
//

import UIKit

protocol StoriesStorkeViewDelegate: class {
  func numberOfStrokes() -> Int
  func strokeViewChangedIndex(index: Int)
  func strokeViewFinishedAllAnimations()
  func strokeViewRewindToPreviousStories()
}

class StoriesStrokeView: UIView {
  
  //MARK: - Private properties
  
  private var numberOfStrokes = 0
  private var hasDoneLayoutSubviews = false // for once
  private var strokes: [Stroke] = []
  private var currentStrokeIndex = 0
  private var isStoped = false
  
  //MARK: - Public properties
  
  var duration: TimeInterval = 4
  var padding: CGFloat = 3
  
  var bottomStrokeColor: UIColor = UIColor.white.withAlphaComponent(0.7) {
    didSet {
      for stroke in strokes {
        stroke.bottomStrokeColor = bottomStrokeColor
      }
    }
  }
  
  var topStrokeColor: UIColor = .white {
    didSet {
      for stroke in strokes {
        stroke.topStrokeColor = topStrokeColor
      }
    }
  }
  
  weak var delegate: StoriesStorkeViewDelegate?
  
  //MARK: - Awake from nib
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = .clear
  }
  
  //MARK: - Delegates
  
  func reloadData() {
    numberOfStrokes = delegate?.numberOfStrokes() ?? 0
  }
  
  //MARK: - Layout subviews
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if hasDoneLayoutSubviews {
      return
    }
    
    let width = (bounds.width / CGFloat(numberOfStrokes))
    for i in 0..<numberOfStrokes {
      let frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: bounds.height)
      let stroke = Stroke(with: frame, and: padding)
      stroke.bottomStrokeColor = self.bottomStrokeColor
      stroke.topStrokeColor = self.topStrokeColor
      strokes.append(stroke)
      layer.addSublayer(stroke.bottomStroke)
      layer.addSublayer(stroke.topStroke)
    }
    
    hasDoneLayoutSubviews = true
  }
  
  //MARK: - Animation
  
  func startAnimating() {
    animate()
  }
  
  private func animate(at index: Int = 0) {
    if !isStoped { currentStrokeIndex = index }
    print(currentStrokeIndex)
    let animation = CABasicAnimation(keyPath: "strokeEnd")
    animation.fromValue = 0
    animation.toValue = 1
    animation.duration = duration
    animation.fillMode = CAMediaTimingFillMode.forwards
    animation.isRemovedOnCompletion = false
    
    animation.completion = { finished in
      if finished {
        self.strokes[self.currentStrokeIndex].isSeen = true
        self.isStoped = false
        self.next()
      }
    }
    
    if strokes.last?.isSeen == true {
      currentStrokeIndex = strokes.count - 1
      strokes.last?.topStroke.add(animation, forKey: "line")
    } else {
      if let beginingStroke = strokes.first(where: { $0.isSeen == false  }) {
        beginingStroke.topStroke.add(animation, forKey: "line")
      } else {
        strokes[index].topStroke.add(animation, forKey: "line")
      }
    }
    
  }
  
  func stopAnimating() {
    isStoped = true
    let currentStroke = strokes[currentStrokeIndex].topStroke
    currentStroke.strokeEnd = 0
    currentStroke.speed = 1
    currentStroke.timeOffset = 0
    currentStroke.beginTime = 0
    currentStroke.removeAllAnimations()
  }
  
  func pauseAnimating(hide: Bool = true) {
    if hide {
      UIView.animate(withDuration: 0.3) {
        self.alpha = 0
      }
    }
    
    let currentStroke = strokes[currentStrokeIndex].topStroke
    let pausedTime : CFTimeInterval = currentStroke.convertTime(CACurrentMediaTime(), from: nil)
    currentStroke.speed = 0.0
    currentStroke.timeOffset = pausedTime
  }
  
  func resumeAnimating() {
    UIView.animate(withDuration: 0.3) {
      self.alpha = 1
    }
    let currentStroke = strokes[currentStrokeIndex].topStroke
    let pausedTime = currentStroke.timeOffset
    currentStroke.speed = 1.0
    currentStroke.timeOffset = 0
    currentStroke.beginTime = 0
    let timeSincePause = currentStroke.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    currentStroke.beginTime = timeSincePause
  }
  
  //MARK: - Actions
  
  private func next() {
    let newIndex = currentStrokeIndex + 1
    isStoped = false
    if newIndex < strokes.count {
      animate(at: newIndex)
      delegate?.strokeViewChangedIndex(index: newIndex)
    } else {
      delegate?.strokeViewFinishedAllAnimations()
    }
  }
  
  func skip() {
    let newIndex = currentStrokeIndex + 1
    if newIndex == strokes.count {
      delegate?.strokeViewFinishedAllAnimations()
    } else {
      let currentStroke = strokes[currentStrokeIndex]
      currentStroke.topStroke.strokeEnd = 1
      currentStroke.isSeen = true
      currentStroke.topStroke.removeAllAnimations()
      next()
    }
  }
  
  func rewind() {
    isStoped = false
    if currentStrokeIndex == 0 {
      delegate?.strokeViewRewindToPreviousStories()
    } else {
      let currentStroke = strokes[currentStrokeIndex]
      currentStroke.topStroke.strokeEnd = 0
      currentStroke.isSeen = false
      currentStroke.topStroke.removeAllAnimations()
      let newIndex = max(currentStrokeIndex - 1, 0)
      let prevStroke = strokes[newIndex]
      prevStroke.topStroke.strokeEnd = 0
      prevStroke.isSeen = false
      animate(at: newIndex)
      delegate?.strokeViewChangedIndex(index: newIndex)
    }
  }

}

fileprivate class Stroke {
  
  //MARK: - Private properties
  private var frame: CGRect
  private let lineWidth: CGFloat = 3
  private let padding: CGFloat
  
  //MARK: - Public properties
  var bottomStrokeColor = UIColor.white.withAlphaComponent(0.7) {
    didSet {
      bottomStroke.strokeColor = bottomStrokeColor.cgColor
    }
  }
  var topStrokeColor = UIColor.white {
    didSet {
      topStroke.strokeColor = topStrokeColor.cgColor
    }
  }
  
  //MARK: - Init
  
  init(with frame: CGRect, and padding: CGFloat) {
    self.frame = frame
    self.padding = padding
  }
  
  
  lazy var bottomStroke: CAShapeLayer = {
    let shapeLayer = CAShapeLayer()
    shapeLayer.frame = frame
    shapeLayer.lineWidth = lineWidth
    shapeLayer.fillColor = nil
    shapeLayer.strokeEnd = 1
    shapeLayer.lineCap = CAShapeLayerLineCap.round
    shapeLayer.strokeColor = bottomStrokeColor.cgColor
    
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0 + padding, y: frame.height / 2))
    path.addLine(to: CGPoint(x: frame.width - padding, y: frame.height / 2))
    
    shapeLayer.path = path.cgPath
    
    return shapeLayer
  }()
  
  lazy var topStroke: CAShapeLayer = {
    let shapeLayer = CAShapeLayer()
    shapeLayer.frame = frame
    shapeLayer.lineWidth = lineWidth
    shapeLayer.fillColor = nil
    shapeLayer.strokeEnd = 0
    shapeLayer.lineCap = CAShapeLayerLineCap.round
    shapeLayer.strokeColor = topStrokeColor.cgColor
    
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0 + padding, y: frame.height / 2))
    path.addLine(to: CGPoint(x: frame.width - padding, y: frame.height / 2))
    
    shapeLayer.path = path.cgPath
    
    return shapeLayer
  }()
  
  var isSeen = false
}
