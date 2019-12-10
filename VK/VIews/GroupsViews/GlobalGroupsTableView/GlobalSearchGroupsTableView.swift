import UIKit


class GlobalSearchGroupsTableView: UITableViewController {

    var dataGlobalGroups: [String] = ["Swift Develop Group 1", "Swift Develop Group 2", "Swift Develop Group 3", "Swift Develop Group 4" , "Swift Develop Group 5", "Swift Develop Group 6", "Swift Develop Group 7", "Swift Develop Group 8", "Swift Develop Group 9"]

    @IBOutlet var globalSearchGroupView: UITableView!
    
    //реализация количества строк (ячеек) равное количеству элементов массива dataGlobalGroups
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataGlobalGroups.count
    }
    //реализация присвоения титулу ячеек значений элементов массива dataGlobalGroups, идентификатор CellGlobalGroups задается в Storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellGlobalGroups", for: indexPath) as! GlobalGroupsCell
        let globalGroup = dataGlobalGroups[indexPath.row]
        cell.globalGroupsName.text = globalGroup
        let image = UIImage(named: "swift")
        cell.globalGroupImage.image = image
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
        //выведем в консоль имя нажатой ячейки
        print(dataGlobalGroups[indexPath.row])
    }

    override func viewDidLoad() {
        print("[Logging] load Global Search Groups View")
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
