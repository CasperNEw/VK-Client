import UIKit

class ProfileForm: UITabBarController {
    var username = ""
    var language = 0
    
    //реализация метода получения данных с предыдущего View
    override func viewDidLoad() {
        print("[Logging] connect with username - \(username)")
        if language == 0 {
            print("[Logging] connect with language option Ru")
        } else {
            print("[Logging] connect with language option En")
        }
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
//    подумать как можно реализовать передачу данных при переходе без Segue!
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("[Logging] jump to \(String(describing: segue.identifier))")
//        //Реализация передачи данных при Segue
//        if let toVC = segue.destination as? FriendsTableView {
//            toVC.username = username
//            toVC.language = language
//        }
//    }
    
}
