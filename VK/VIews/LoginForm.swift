
import UIKit

class LoginForm: UIViewController {

    @IBOutlet weak var authorizationLabel: UILabel!
    @IBOutlet weak var switchLanguage: UISegmentedControl!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var loginForm: UITextField!
    @IBOutlet weak var passworfLabel: UILabel!
    @IBOutlet weak var passwordForm: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var scrollMainViewForm: UIScrollView!
    
    
    @IBAction func loginButton(_ sender: Any) {
        let login = loginForm.text!
        print("[Logging] try to connect with username:\(login)")
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let login = loginForm.text!
        let password = passwordForm.text!
        
        if login == "admin" && password == "admin" {
            return true
        } else {
            //Создали контроллер, кнопку и визуализацию самого сообщения об ошибке
            print("[Logging] incorrect data, username - \(login) | password - \(password)")
            if switchLanguage.selectedSegmentIndex == 0 {
                let alert = UIAlertController(title: "Ошибка", message: "Введены неверные данные пользователя", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return false
            } else {
                let alert = UIAlertController(title: "Error", message: "Incorrect user data entered", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                return false
            }
            
        }
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        loginForm.text = "admin"
        passwordForm.text = "admin"
    }
    var languageInt: Int = 0
    @IBAction func switchLanguage(_ sender: Any) {
        if switchLanguage.selectedSegmentIndex == 0 {
            authorizationLabel.text = "Авторизация"
            loginLabel.text = "Телефон или e-mail"
            passworfLabel.text = "Пароль"
            loginButton.setTitle("Войти", for: .normal)
            forgotPasswordButton.setTitle("Забыли пароль?", for: .normal)
        } else {
            authorizationLabel.text = "Authorization    "
            loginLabel.text = "Phone or e-mail"
            passworfLabel.text = "Password"
            loginButton.setTitle("Login", for: .normal)
            forgotPasswordButton.setTitle("Forgot your password?", for: .normal)
        }
        languageInt = switchLanguage.selectedSegmentIndex
    }
    // функция для возврата на данный экран , объявляем там куда хотим вернуться
    // button -> "Exit" on View upSettings, использована в реализации кнопки - Logout
    @IBAction func goToLofinForm (unwindSegue: UIStoryboardSegue) {
        print("[Logging] User \(loginForm.text ?? "Unknown") disconnected")
    }
    
    //Реализация метода фиксации Segue ( прыгаем по переходу Profile Form )
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("[Logging] jump to \(String(describing: segue.identifier))")
        //Реализация передачи данных при Segue
        if let toVC = segue.destination as? ProfileForm {
            toVC.username = loginForm.text ?? ""
            toVC.language = languageInt
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // реализация метода появления и исчезновения клавиатуры
        let hideAction = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideAction)

    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    
    @IBAction func testButtonOne(_ sender: Any) {
        
        let main = UIStoryboard( name: "Main", bundle: nil)
        let vc = main.instantiateViewController(identifier: "GroupInfoView") as! GroupInfoTableView
        //vc.user = friendsSection[indexPath.section].items[indexPath.row].username
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
