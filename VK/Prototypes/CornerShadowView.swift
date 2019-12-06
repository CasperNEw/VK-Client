//Реализация класса для custom View с возможностью создания радиуса, ободка и тени
//внутри View данного класса создается объект (Subview) UIImageView

import UIKit

class CornerShadowView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 20 { didSet { updateRadius() } }
    @IBInspectable var borderColor: UIColor = .darkGray { didSet { updateBorderColor() } }
    @IBInspectable var borderWidth: CGFloat = 2 { didSet { updateBorderWidth() } }
    @IBInspectable var shadowColor: UIColor = .black { didSet { updateShadowColor() } }
    @IBInspectable var shadowRadius: CGFloat = 5 { didSet { updateShadowRadius() } }
    @IBInspectable var shadowOpacity: Float = 0.5 { didSet { updateShadowOpacity() } }
    
    var imageView = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
        layer.shadowOpacity = shadowOpacity
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        
        clipsToBounds = true
        layer.masksToBounds = false
        
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.borderColor = borderColor.cgColor
        imageView.layer.borderWidth = borderWidth
        imageView.clipsToBounds = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: imageView.superview!.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageView.superview!.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: imageView.superview!.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: imageView.superview!.trailingAnchor).isActive = true
    }
    
    func updateRadius() {
        self.layer.cornerRadius = cornerRadius
        //self.layer.shadowRadius = cornerRadius
        self.imageView.layer.cornerRadius = cornerRadius
    }
    func updateBorderColor() {
        self.layer.borderColor = borderColor.cgColor
        imageView.layer.borderColor = borderColor.cgColor
    }
    func updateBorderWidth() {
        self.layer.borderWidth = borderWidth
        imageView.layer.borderWidth = borderWidth
    }
    func updateShadowColor() {
        self.layer.shadowColor = shadowColor.cgColor
    }
    func updateShadowRadius() {
        self.layer.shadowRadius = shadowRadius
    }
    func updateShadowOpacity() {
        self.layer.shadowOpacity = shadowOpacity
    }
}
