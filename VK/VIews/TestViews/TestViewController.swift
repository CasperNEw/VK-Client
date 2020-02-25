import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var CircleIndOne: UIImageView!
    @IBOutlet weak var CircleIndTwo: UIImageView!
    @IBOutlet weak var CircleIndThree: UIImageView!
    @IBOutlet weak var vkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAnimation()
        vkButton.imageView?.layer.cornerRadius = 7
        // реализация метода появления и исчезновения клавиатуры
        let hideAction = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideAction)
        // добавляем метод отслеживания нажатия
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panRecognize(_:)) )
        view.addGestureRecognizer(panGesture)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    //добавляем Property анимацию
    var propertyAnimator: UIViewPropertyAnimator!
    
    @objc func panRecognize(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            //в начале тапа инициализируем начало трансформации
            propertyAnimator = UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.4, animations: {
                self.vkButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            })
        case .changed:
            //которое при движении по координате "у", будет увеличивать scale нашей кнопки в процентном отношении
            let translation = recognizer.translation(in: self.view)
            propertyAnimator.fractionComplete = translation.y / 100
        case .ended:
            //возвращаем изначальное состояние при окончании тапа
            propertyAnimator.stopAnimation(true)
            propertyAnimator.addAnimations {
                self.vkButton.transform = .identity
            }
            //стартуем анимацию
            propertyAnimator.startAnimation()
        default: break
        }
    }
    
    func loadAnimation() {
        
        // более естественно выглядит когда изначально индикаторы скрыты
        CircleIndOne.alpha = 0
        CircleIndTwo.alpha = 0
        CircleIndThree.alpha = 0
        
        UIView.animate(withDuration: 1,
                       delay: 0,
                       options: [.repeat, .autoreverse],
                       animations: {self.CircleIndOne.alpha = 1})
        
        UIView.animate(withDuration: 1,
                       delay: 0.5,
                       options: [.repeat, .autoreverse],
                       animations: {self.CircleIndTwo.alpha = 1})
        
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: [.repeat, .autoreverse],
                       animations: {self.CircleIndThree.alpha = 1})
    }
    
    @IBAction func parallaxButtonPush(_ sender: Any) {
        let main = UIStoryboard( name: "Main", bundle: nil)
        let vc = main.instantiateViewController(identifier: "GroupInfoView") as! UserProfileTableView
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchBarButtonPush(_ sender: Any) {
        let main = UIStoryboard( name: "Main", bundle: nil)
        let vc = main.instantiateViewController(identifier: "SearchBarTestView") as! TestTableViewController
        navigationController?.pushViewController(vc, animated: true)
        print("[Logging] func SearchBarButtonPush")
    }
    
    @IBAction func animateButtonPush(_ sender: Any) {
        let main = UIStoryboard( name: "Main", bundle: nil)
        let vc = main.instantiateViewController(identifier: "TestAnimateView") as! TestAnimateViewController
        navigationController?.pushViewController(vc, animated: true)
        print("[Logging] func animateButtonPush")
    }
    
    @IBAction func vkButtonPush(_ sender: Any) {
        //пробуем Keyframes animations
        UIView.animateKeyframes(withDuration: 5.0, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1) { self.vkButton.center.y -= 60 }
            UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1) { self.vkButton.center.x = self.vkButton.frame.width }
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) { self.vkButton.center.y += 120 }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2) { self.vkButton.center.x = self.view.frame.width - self.vkButton.frame.width }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.1) { self.vkButton.center.y -= 120 }
            UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.2) { self.vkButton.center.x = self.view.frame.width / 2 }
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) { self.vkButton.center.y += 60 }
        }, completion: nil)
    }
    
}
