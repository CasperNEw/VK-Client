import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var CircleIndOne: UIImageView!
    @IBOutlet weak var CircleIndTwo: UIImageView!
    @IBOutlet weak var CircleIndThree: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAnimation()
        // реализация метода появления и исчезновения клавиатуры
        let hideAction = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideAction)
        
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
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
        let vc = main.instantiateViewController(identifier: "GroupInfoView") as! GroupInfoTableView
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchBarButtonPush(_ sender: Any) {
        let main = UIStoryboard( name: "Main", bundle: nil)
        let vc = main.instantiateViewController(identifier: "SearchBarTestView") as! TestTableViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
