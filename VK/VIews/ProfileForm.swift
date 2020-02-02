import UIKit

class ProfileForm: UITabBarController {
    var username = ""
    var language = 0
    
   //Реализация скрытия NavigationBar на данном контроллере и появлении на последующих
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
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
}
