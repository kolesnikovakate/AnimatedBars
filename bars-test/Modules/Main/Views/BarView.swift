//
//  BarView.swift
//  bars-test
//
//  Created by Ekaterina Kolesnikova on 27/07/2019.
//  Copyright © 2019 kolesnikovakate. All rights reserved.
//

import UIKit

final class BarView: UIView {
    
    private let progressLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var progress: Float = 0
    private var fillColor: UIColor = .blue
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    var barWidth: CGFloat = 20 {
        didSet {
            setup()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func configure(withBarInfo barInfo: BarInfo) {
        progress = barInfo.progress
        fillColor = UIColor.init(barInfo.color)
        animateProgress()
    }
}

// MARK: - Private
private extension BarView {
    
    var cornerRadius: CGFloat {
        return barWidth / 4
    }
    
    var progressPath: UIBezierPath {
        let progressHeight = bounds.size.height * CGFloat(progress)
        let progressY = bounds.origin.y + bounds.size.height - progressHeight
        let rect = CGRect.init(x: 0, y: progressY, width: barWidth, height: progressHeight)
        return UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
    }
    
    func setup() {
        let backgroundRect = CGRect.init(x: (bounds.width - barWidth) / 2, y: bounds.origin.y,
                                         width: barWidth, height: bounds.size.height)
        
        backgroundLayer.removeFromSuperlayer()
        backgroundLayer.frame = backgroundRect
        backgroundLayer.backgroundColor = UIColor.black.cgColor
        backgroundLayer.cornerRadius = cornerRadius
        backgroundLayer.masksToBounds = true
        
        progressLayer.removeFromSuperlayer()
        progressLayer.frame = backgroundLayer.bounds
        progressLayer.path = progressPath.cgPath
        progressLayer.fillColor = fillColor.cgColor
        
        layer.addSublayer(backgroundLayer)
        backgroundLayer.addSublayer(progressLayer)
    }
    
    func animateProgress() {
        
        CATransaction.begin()
        let newPath = progressPath
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = progressLayer.path
        pathAnimation.toValue = newPath.cgPath
        
        let colorAnimation = CABasicAnimation(keyPath: "fillColor")
        colorAnimation.fromValue = progressLayer.fillColor
        colorAnimation.toValue = fillColor.cgColor
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 0.3
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        groupAnimation.fillMode = .forwards
        groupAnimation.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {[weak self] in
            guard let `self` = self else { return }
            self.progressLayer.path = newPath.cgPath
            self.progressLayer.fillColor = self.fillColor.cgColor
            self.progressLayer.removeAllAnimations()
        }
        
        groupAnimation.animations = [pathAnimation, colorAnimation]
        progressLayer.add(groupAnimation, forKey: nil)
        
        CATransaction.commit()
    }
}
