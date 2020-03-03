import UIKit

class CornerImageView: UIImageView {
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        initImage()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initImage()
    }
    
    func initImage() {
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
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
