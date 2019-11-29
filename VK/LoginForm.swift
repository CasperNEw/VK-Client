//Complete homework , lesson 1 & 2
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
    @IBOutlet weak var ScrollMainViewForm: UIScrollView!
    
    
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
    @IBAction func goToLofinForm (unwindSegue: UIStoryboardSegue) {}
    
    //Реализация метода фиксации Segue ( прыгаем по переходу Profile Form )
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("[Logging] jump to \(String(describing: segue.identifier))")
        //Реализация передачи данных при Segue
        if let toVC = segue.destination as? ProfileForm {
            toVC.username = loginForm.text ?? ""
            toVC.language = languageInt
        }
        //Подумать как добавить передачу Bool значения языка !
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
}

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
}
var dataFriends: [String] = ["Friend_One", "Friend_Two", "Friend_Three", "Friend_Four", "Friend_Five"]

class FriendsTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //реализация количества строк (ячеек) равное количеству элементов массива dataFriens
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFriends.count
    }
    //реализация присвоения титулу ячеек значений элементов массива data, идентификатор CellFriends задается в Storyboard
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFriends", for: indexPath)
        cell.textLabel?.text = dataFriends[indexPath.row]
        return cell
    }
    //реализация функции при нажатии на Cell
    //let main =  UIStoryboard()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
        //выведем в консоль имя нажатой ячейки
        print(dataFriends[indexPath.row])
        //сделаем переключение на Collection View, со всех ячеек переключаемся на один и тот же Collection View.
        let main = UIStoryboard( name: "Main", bundle: nil)
        let vc = main.instantiateViewController(identifier: "PhotoFreindsCollection")
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBOutlet var friendsTView: UITableView!
    
    var username = ""
    //реализация метода получения данных с предыдущего View
    override func viewDidLoad() {
        print("[Logging] load Friends & Photo View")
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

var dataGroups: [String] = ["Group_One", "Group_Two", "Group_Three", "Group_Four", "Group_Five"]

class GroupsTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var GroupsView: UITableView!
    //реализация количества строк (ячеек) равное количеству элементов массива dataGroups
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataGroups.count
    }
    //реализация присвоения титулу ячеек значений элементов массива dataGroups, идентификатор CellGroups задается в Storyboard
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellGroups", for: indexPath)
        cell.textLabel?.text = dataGroups[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
        //выведем в консоль имя нажатой ячейки
        print(dataGroups[indexPath.row])
        //сделаем переключение на alert - Error! так как у нас пока нет внутренностей для групп
        let alert = UIAlertController(title: "Error", message: "Access error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        print("[Logging] load Groups View")
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

var dataGlobalGroups: [String] = ["Swift Develop Group 1", "Swift Develop Group 2", "Swift Develop Group 3", "Swift Develop Group 4" , "Swift Develop Group 5", "Swift Develop Group 6", "Swift Develop Group 7", "Swift Develop Group 8", "Swift Develop Group 9"]

class GlobalSearchGroupsTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var GlobalSearchGroupView: UITableView!
    
    //реализация количества строк (ячеек) равное количеству элементов массива dataGroups
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataGlobalGroups.count
    }
    //реализация присвоения титулу ячеек значений элементов массива dataGroups, идентификатор CellGlobalGroups задается в Storyboard
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellGlobalGroups", for: indexPath)
        cell.textLabel?.text = dataGlobalGroups[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
        //выведем в консоль имя нажатой ячейки
        print(dataGlobalGroups[indexPath.row])
        //сделаем переключение на alert - Error! так как у нас пока нет внутренностей для групп
        let alert = UIAlertController(title: "Error", message: "Access error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        print("[Logging] load Global Search Groups View")
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

class FriendsPhotoCollectionView: UICollectionViewController {
    override func viewDidLoad() {
        print("[Logging] load Friends Photo Collection View")
    }
}
class GroupInfoTableView: UITableViewController {
    override func viewDidLoad() {
        print("[Logging] load Group Info Table View")
    }
}
