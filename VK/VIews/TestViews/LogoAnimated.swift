import UIKit

class AnimationLogo: UIView {
    
    //VK Logo draw
    let VKLogoPath: UIBezierPath = {
        
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 100.96, y: 164.5))
        bezier2Path.addLine(to: CGPoint(x: 112.32, y: 164.5))
        bezier2Path.addCurve(to: CGPoint(x: 117.5, y: 161.99), controlPoint1: CGPoint(x: 112.32, y: 164.5), controlPoint2: CGPoint(x: 115.75, y: 164.08))
        bezier2Path.addCurve(to: CGPoint(x: 119.06, y: 156.47), controlPoint1: CGPoint(x: 119.11, y: 160.07), controlPoint2: CGPoint(x: 119.06, y: 156.47))
        bezier2Path.addCurve(to: CGPoint(x: 125.91, y: 137.11), controlPoint1: CGPoint(x: 119.06, y: 156.47), controlPoint2: CGPoint(x: 118.84, y: 139.6))
        bezier2Path.addCurve(to: CGPoint(x: 151.33, y: 160.63), controlPoint1: CGPoint(x: 132.88, y: 134.66), controlPoint2: CGPoint(x: 141.84, y: 153.42))
        bezier2Path.addCurve(to: CGPoint(x: 163.95, y: 164.89), controlPoint1: CGPoint(x: 158.5, y: 166.08), controlPoint2: CGPoint(x: 163.95, y: 164.89))
        bezier2Path.addLine(to: CGPoint(x: 189.33, y: 164.5))
        bezier2Path.addCurve(to: CGPoint(x: 196.31, y: 152.04), controlPoint1: CGPoint(x: 189.33, y: 164.5), controlPoint2: CGPoint(x: 202.6, y: 163.59))
        bezier2Path.addCurve(to: CGPoint(x: 177.44, y: 127.87), controlPoint1: CGPoint(x: 195.79, y: 151.09), controlPoint2: CGPoint(x: 192.64, y: 143.49))
        bezier2Path.addCurve(to: CGPoint(x: 182.83, y: 85.89), controlPoint1: CGPoint(x: 161.53, y: 111.52), controlPoint2: CGPoint(x: 163.66, y: 114.17))
        bezier2Path.addCurve(to: CGPoint(x: 197.71, y: 53.65), controlPoint1: CGPoint(x: 194.5, y: 68.67), controlPoint2: CGPoint(x: 199.16, y: 58.15))
        bezier2Path.addCurve(to: CGPoint(x: 187.73, y: 50.49), controlPoint1: CGPoint(x: 196.32, y: 49.36), controlPoint2: CGPoint(x: 187.73, y: 50.49))
        bezier2Path.addLine(to: CGPoint(x: 159.16, y: 50.69))
        bezier2Path.addCurve(to: CGPoint(x: 155.47, y: 51.41), controlPoint1: CGPoint(x: 159.16, y: 50.69), controlPoint2: CGPoint(x: 157.04, y: 50.37))
        bezier2Path.addCurve(to: CGPoint(x: 152.95, y: 54.8), controlPoint1: CGPoint(x: 153.94, y: 52.43), controlPoint2: CGPoint(x: 152.95, y: 54.8))
        bezier2Path.addCurve(to: CGPoint(x: 142.4, y: 79.46), controlPoint1: CGPoint(x: 152.95, y: 54.8), controlPoint2: CGPoint(x: 148.43, y: 68.13))
        bezier2Path.addCurve(to: CGPoint(x: 122.51, y: 103.16), controlPoint1: CGPoint(x: 129.68, y: 103.38), controlPoint2: CGPoint(x: 124.59, y: 104.64))
        bezier2Path.addCurve(to: CGPoint(x: 118.88, y: 81.84), controlPoint1: CGPoint(x: 117.67, y: 99.7), controlPoint2: CGPoint(x: 118.88, y: 89.25))
        bezier2Path.addCurve(to: CGPoint(x: 112.7, y: 46.49), controlPoint1: CGPoint(x: 118.88, y: 58.66), controlPoint2: CGPoint(x: 122.06, y: 49))
        bezier2Path.addCurve(to: CGPoint(x: 99.37, y: 45.03), controlPoint1: CGPoint(x: 109.6, y: 45.66), controlPoint2: CGPoint(x: 107.31, y: 45.12))
        bezier2Path.addCurve(to: CGPoint(x: 75.66, y: 47.71), controlPoint1: CGPoint(x: 89.17, y: 44.91), controlPoint2: CGPoint(x: 80.55, y: 45.06))
        bezier2Path.addCurve(to: CGPoint(x: 71.43, y: 53.62), controlPoint1: CGPoint(x: 72.41, y: 49.47), controlPoint2: CGPoint(x: 69.9, y: 53.4))
        bezier2Path.addCurve(to: CGPoint(x: 79.86, y: 58.32), controlPoint1: CGPoint(x: 73.32, y: 53.9), controlPoint2: CGPoint(x: 77.59, y: 54.9))
        bezier2Path.addCurve(to: CGPoint(x: 82.69, y: 72.63), controlPoint1: CGPoint(x: 82.79, y: 62.73), controlPoint2: CGPoint(x: 82.69, y: 72.63))
        bezier2Path.addCurve(to: CGPoint(x: 78.76, y: 103.3), controlPoint1: CGPoint(x: 82.69, y: 72.63), controlPoint2: CGPoint(x: 84.37, y: 99.91))
        bezier2Path.addCurve(to: CGPoint(x: 58.28, y: 79.18), controlPoint1: CGPoint(x: 74.91, y: 105.62), controlPoint2: CGPoint(x: 69.62, y: 100.88))
        bezier2Path.addCurve(to: CGPoint(x: 48.08, y: 55.78), controlPoint1: CGPoint(x: 52.47, y: 68.07), controlPoint2: CGPoint(x: 48.08, y: 55.78))
        bezier2Path.addCurve(to: CGPoint(x: 45.73, y: 52.26), controlPoint1: CGPoint(x: 48.08, y: 55.78), controlPoint2: CGPoint(x: 47.24, y: 53.49))
        bezier2Path.addCurve(to: CGPoint(x: 41.34, y: 50.3), controlPoint1: CGPoint(x: 43.9, y: 50.77), controlPoint2: CGPoint(x: 41.34, y: 50.3))
        bezier2Path.addLine(to: CGPoint(x: 14.19, y: 50.49))
        bezier2Path.addCurve(to: CGPoint(x: 8.62, y: 52.58), controlPoint1: CGPoint(x: 14.19, y: 50.49), controlPoint2: CGPoint(x: 10.12, y: 50.62))
        bezier2Path.addCurve(to: CGPoint(x: 8.51, y: 57.94), controlPoint1: CGPoint(x: 7.29, y: 54.33), controlPoint2: CGPoint(x: 8.51, y: 57.94))
        bezier2Path.addCurve(to: CGPoint(x: 53.83, y: 140.73), controlPoint1: CGPoint(x: 8.51, y: 57.94), controlPoint2: CGPoint(x: 29.77, y: 112.99))
        bezier2Path.addCurve(to: CGPoint(x: 100.96, y: 164.5), controlPoint1: CGPoint(x: 75.9, y: 166.17), controlPoint2: CGPoint(x: 100.96, y: 164.5))
        bezier2Path.close()
        UIColor.clear.setFill()
        bezier2Path.fill()
        UIColor.darkGray.setStroke()
        bezier2Path.lineWidth = 1
        bezier2Path.stroke()
        
        return bezier2Path
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let customLayer = CAShapeLayer()
        customLayer.path = VKLogoPath.cgPath
        customLayer.fillColor = UIColor.clear.cgColor
        customLayer.strokeColor = UIColor(red: 70.0/255.0, green: 128.0/255.0, blue: 194.0/255.0, alpha: 1.0).cgColor
        customLayer.backgroundColor = UIColor.clear.cgColor
        customLayer.lineWidth = 4
        
        let strokeAnimationStart = CABasicAnimation(keyPath: "strokeStart")
        strokeAnimationStart.fromValue = 0
        strokeAnimationStart.toValue = 1.0
        
        let strokeAnimationEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimationEnd.fromValue = 0
        strokeAnimationEnd.toValue = 1.4
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 1.3
        groupAnimation.animations = [strokeAnimationStart, strokeAnimationEnd]
        groupAnimation.autoreverses = true
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
        
        customLayer.add(groupAnimation, forKey: nil)
        layer.addSublayer(customLayer)
    }
}
