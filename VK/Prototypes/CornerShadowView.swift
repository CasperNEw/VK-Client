//Реализация класса для custom View с возможностью создания радиуса, ободка и тени
//внутри View данного класса создается объект (Subview) UIImageView
//радиус реализуется на Subview, а тень реализуется на самом View
//upd^ добавлена анимация по нажатию на View

import UIKit

class CornerShadowView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 25 { didSet { updateRadius() } }
    @IBInspectable var borderColor: UIColor = .darkGray { didSet { updateBorderColor() } }
    @IBInspectable var borderWidth: CGFloat = 1 { didSet { updateBorderWidth() } }
    @IBInspectable var shadowColor: UIColor = .black { didSet { updateShadowColor() } }
    @IBInspectable var shadowRadius: CGFloat = 3 { didSet { updateShadowRadius() } }
    @IBInspectable var shadowOpacity: Float = 1 { didSet { updateShadowOpacity() } }
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        addImage()
        initImage()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addImage()
        initImage()
    }
    
    func updateRadius() {
        imageView.layer.cornerRadius = cornerRadius
    }
    func updateBorderColor() {
        imageView.layer.borderColor = borderColor.cgColor
    }
    func updateBorderWidth() {
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
    
    func addImage() {
        imageView = UIImageView(frame: frame)
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        imageView.frame = bounds
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.masksToBounds = false
        
        //imageView.layer.cornerRadius = bounds.size.height / 2 //реализация круга
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
    }
    
    func initImage() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
    }
    
    //добавляем функцию анимации при нажатии
    private func animatedImage() {
        let animation = CASpringAnimation(keyPath: "transform.scale") //что будем менять
        animation.fromValue = 0.9 //стартовое значение
        animation.toValue = 1 //конечно значение
        animation.stiffness = 500 //жесткость пружины
        animation.mass = 1 //масса
        animation.duration = 1 //продолжительность анимации
        animation.beginTime = CACurrentMediaTime() //время старта анимации, дефолтное значение
        animation.fillMode = .both
        layer.add(animation, forKey: nil) //добавляем к слою текущую анимацию
    }
    
    @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
        animatedImage()
    }
}
