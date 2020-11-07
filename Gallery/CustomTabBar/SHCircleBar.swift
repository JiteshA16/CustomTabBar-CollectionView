//
//  SHCircleBar.swift
//  SHCircleBar
//
//  Created by Adrian Perțe on 19/02/2019.
//  Copyright © 2019 softhaus. All rights reserved.
//

import UIKit

@IBDesignable class SHCircleBar: UITabBar {
    var tabWidth: CGFloat = 0
    var index: CGFloat = 0 {
        willSet{
            self.previousIndex = index
        }
    }
    private var animated = false
    private var selectedImage: UIImage?
    private var previousIndex: CGFloat = 0
    private var selectedIndex: CGFloat = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
        
    }
    override func draw(_ rect: CGRect) {
        let fillColor: UIColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        tabWidth = self.bounds.width / CGFloat(self.items!.count)
        let bezPath = drawPath(for: index)
        
        bezPath.close()
        fillColor.setFill()
        bezPath.fill()
        let mask = CAShapeLayer()
        mask.fillRule = .evenOdd
        mask.fillColor = UIColor.white.cgColor
        mask.path = bezPath.cgPath
        
        if self.layer.sublayers?.count ?? 0 > 0 {
            self.layer.sublayers?.forEach{$0.name == "LineLayer" ? $0.removeFromSuperlayer() : nil}
            self.layer.sublayers?.forEach{$0.name == "ShadowLayer" ? $0.removeFromSuperlayer() : nil}
        }
        
        
        let line = CAShapeLayer()
        
        line.path = bezPath.cgPath
        //UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0).cgColor

        line.strokeColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0).cgColor
        line.fillColor = UIColor.clear.cgColor
        line.lineWidth = 2.0
        line.name = "LineLayer"
        self.layer.addSublayer(line)
        
        let shadowSubLayer = createShadowLayer(shadowColor: UIColor.darkGray, alpha: 0.7)
        shadowSubLayer.name = "ShadowLayer"
        shadowSubLayer.insertSublayer(line, at: 0)
        self.layer.addSublayer(shadowSubLayer)
        
        if (self.animated) {
            let bezAnimation = CABasicAnimation(keyPath: "path")
            let bezPathFrom = drawPath(for: previousIndex)
            bezAnimation.toValue = bezPath.cgPath
            bezAnimation.fromValue = bezPathFrom.cgPath
            bezAnimation.duration = 0.3
            bezAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            mask.add(bezAnimation, forKey: nil)
        }
        self.layer.mask = mask
        
    }
    
    func select(itemAt: Int, animated: Bool) {
        self.selectedIndex = CGFloat(itemAt)
        self.index = CGFloat(itemAt)
        self.animated = animated
        self.selectedImage = self.selectedItem?.selectedImage
        self.selectedItem?.selectedImage = nil
        self.setNeedsDisplay()
    }
    
    func customInit(){
        self.tintColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        self.barTintColor = .white
        self.backgroundColor = .white
    }
    private func drawPath(for index: CGFloat) -> UIBezierPath {
        let height: CGFloat = 47.0
        let path = UIBezierPath()
        let position = (tabWidth * selectedIndex) + tabWidth / 2
        
        // start top left
        path.move(to: CGPoint(x: 0, y: 0))
        
        // the beginning of the trough
        path.addLine(to: CGPoint(x: (position - height * 2), y: 0))
        
        // first curve down
        path.addCurve(to: CGPoint(x: position, y: height),
                      controlPoint1: CGPoint(x: (position - 30), y: 0), controlPoint2: CGPoint(x: position - 35, y: height))
        // second curve up
        path.addCurve(to: CGPoint(x: (position + height * 2), y: 0),
                      controlPoint1: CGPoint(x: position + 35, y: height), controlPoint2: CGPoint(x: (position + 30), y: 0))
        
        // complete the rect
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path
        
    }
    
    func createShadowLayer(shadowColor: UIColor, alpha: CGFloat) -> CALayer {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = shadowColor.withAlphaComponent(alpha).cgColor
        shadowLayer.shadowOffset = CGSize.zero
        shadowLayer.shadowRadius = 6.0
        shadowLayer.shadowOpacity = 0.8
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        return shadowLayer
    }
}
