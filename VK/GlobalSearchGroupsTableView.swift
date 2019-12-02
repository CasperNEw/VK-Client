import UIKit

var dataGlobalGroups: [String] = ["Swift Develop Group 1", "Swift Develop Group 2", "Swift Develop Group 3", "Swift Develop Group 4" , "Swift Develop Group 5", "Swift Develop Group 6", "Swift Develop Group 7", "Swift Develop Group 8", "Swift Develop Group 9"]

class GlobalSearchGroupsTableView: UITableViewController {

    @IBOutlet var GlobalSearchGroupView: UITableView!
    
    //на всякий случай оставил штатный метод, хотя как я понял он у меня просто вписан в метод tableView
    //но пока оставим, вдруг придется переделать в дальнейшем
    //override func numberOfSections(in tableView: UITableView) -> Int {
    //    return 0
    //}
    
    //реализация количества строк (ячеек) равное количеству элементов массива dataGlobalGroups
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataGlobalGroups.count
    }
    //реализация присвоения титулу ячеек значений элементов массива dataGlobalGroups, идентификатор CellGlobalGroups задается в Storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellGlobalGroups", for: indexPath)
        cell.textLabel?.text = dataGlobalGroups[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
