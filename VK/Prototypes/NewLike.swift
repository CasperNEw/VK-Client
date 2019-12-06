//Реализация класса для активного элемента "Мне нравится"

import UIKit

@IBDesignable class NewLike: UIView {
    
    var newLikeScore = Int.random( in: 1...30 )
    var likeColor = UIColor.darkGray
    
    func setColorRed() {
        likeColor = UIColor.red
        setNeedsDisplay()
    }
    func setColorDarkGrey() {
        likeColor = UIColor.darkGray
        setNeedsDisplay()
    }
    
    func changeScoreUp() {
        newLikeScore += 1
        setNeedsDisplay()
    }
    
    func changeScoreDown() {
        newLikeScore -= 1
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //General Declaration
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        //Color Declaration
        let heartColor = likeColor
            //UIColor.darkGray
        
        //Bezier Drawing
        //let maskLayer = CAShapeLayer() //маскирующий слой
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 10.5, y: 17.5))
        bezierPath.addCurve(to: CGPoint(x: 3.29, y: 12.44), controlPoint1: CGPoint(x: 10.5, y: 17.5), controlPoint2: CGPoint(x: 5.77, y: 14.81))
        bezierPath.addCurve(to: CGPoint(x: 0.58, y: 8.04), controlPoint1: CGPoint(x: 0.81, y: 10.08), controlPoint2: CGPoint(x: 0.87, y: 10.24))
        bezierPath.addCurve(to: CGPoint(x: 2.16, y: 3.64), controlPoint1: CGPoint(x: 0.3, y: 5.84), controlPoint2: CGPoint(x: 0.7, y: 4.96))
        bezierPath.addCurve(to: CGPoint(x: 6.44, y: 2.76), controlPoint1: CGPoint(x: 3.63, y: 2.32), controlPoint2: CGPoint(x: 4.36, y: 2.32))
        bezierPath.addCurve(to: CGPoint(x: 10.5, y: 5.4), controlPoint1: CGPoint(x: 8.53, y: 3.2), controlPoint2: CGPoint(x: 10.5, y: 5.4))
        bezierPath.addCurve(to: CGPoint(x: 14.56, y: 2.76), controlPoint1: CGPoint(x: 10.5, y: 5.4), controlPoint2: CGPoint(x: 12.47, y: 3.2))
        bezierPath.addCurve(to: CGPoint(x: 18.84, y: 3.64), controlPoint1: CGPoint(x: 16.64, y: 2.32), controlPoint2: CGPoint(x: 17.37, y: 2.32))
        bezierPath.addCurve(to: CGPoint(x: 20.42, y: 8.04), controlPoint1: CGPoint(x: 20.3, y: 4.96), controlPoint2: CGPoint(x: 20.7, y: 5.84))
        bezierPath.addCurve(to: CGPoint(x: 17.71, y: 12.44), controlPoint1: CGPoint(x: 20.13, y: 10.24), controlPoint2: CGPoint(x: 20.19, y: 10.08))
        bezierPath.addCurve(to: CGPoint(x: 10.5, y: 17.5), controlPoint1: CGPoint(x: 15.23, y: 14.81), controlPoint2: CGPoint(x: 10.5, y: 17.5))
        heartColor.setStroke()
        bezierPath.lineWidth = 1
        heartColor.setFill()
        if heartColor == UIColor.red {
            bezierPath.fill()
        } else if heartColor == UIColor.darkGray {
            bezierPath.stroke()
        }
        bezierPath.close() //зыркываем последний добавленный путь
        bezierPath.stroke() //отрисовка линии
        //maskLayer.path = bezierPath.cgPath //присваиваем маскирующему слою значение нашего рисунка
        //self.layer.mask = maskLayer //отсекаем всё что за границей нашей маски
      
        //Text Drawing
        let textRect = CGRect(x: 23, y: 2, width: 18, height: 18)
        let textTextContent = "\(newLikeScore)"
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .left
        let textFontAttributes = [
            .font: UIFont.systemFont(ofSize: 13.5),
            .foregroundColor: heartColor,
            .paragraphStyle: textStyle,
            ] as [NSAttributedString.Key: Any]
        
        let textTextHeight: CGFloat = textTextContent.boundingRect(with: CGSize(width: textRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: textRect)
        textTextContent.draw(in: CGRect(x: textRect.minX, y: textRect.minY + (textRect.height - textTextHeight) / 2, width: textRect.width, height: textTextHeight), withAttributes: textFontAttributes)
        context.restoreGState()
    }
    
    //добавляем перерисовку нашего View при смене ориентации, rotate
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
}
