//реализация кастомного UIButton с "лайком" и счетчиком
//для работы надо добавить изображения лайка под именами like dislike
//
//@IBAction func setLike(_ sender: Any) {
//    (sender as! LikeButton).like()
//}


import UIKit

@IBDesignable class LikeButton: UIButton {
    @IBInspectable var liked: Bool = false {
        didSet {
            setupDefault()
        }
    }
    
    var likeCount: Int = 0 {
        didSet {
            setupDefault()
        }
    }
    
    func like() {
        liked = !liked
        
        if liked {
            setLiked()
        } else {
            disableLike()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefault()
    }
    
    private func setupDefault() {
        setImage(UIImage(named: liked ? "like" : "dislike"), for: .normal)
        setTitle(String(describing: likeCount), for: .normal)
        tintColor = liked ? .red : .darkGray
        setTitleColor( liked ? .red : .darkGray, for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        imageView?.contentMode = .scaleAspectFill
        
    }
    
    private func setLiked() {
        likeCount += 1
        setImage(UIImage(named: "like"), for: .normal)
        setTitle(String(describing: likeCount), for: .normal)
        tintColor = .red
        animatedLikeButton()
    }
    
    private func disableLike() {
        likeCount -= 1
        setImage(UIImage(named: "dislike"), for: .normal)
        setTitle(String(describing: likeCount), for: .normal)
        tintColor = .darkGray
        animatedLikeButton()
    }
    
    //добавляем функцию анимации при нажатии
    private func animatedLikeButton() {
        let animation = CASpringAnimation(keyPath: "transform.scale") //что будем менять
        animation.fromValue = 1.1 //стартовое значение
        animation.toValue = 1 //конечно значение
        animation.stiffness = 500 //жесткость пружины
        animation.mass = 1 //масса
        animation.duration = 1 //продолжительность анимации
        animation.beginTime = CACurrentMediaTime() //время старта анимации, дефолтное значение
        animation.fillMode = .both
        layer.add(animation, forKey: nil) //добавляем к слою текущую анимацию
    }
}
