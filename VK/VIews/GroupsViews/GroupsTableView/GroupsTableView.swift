import UIKit

var dataGroups = [String]()

class GroupsTableView: UITableViewController {
    
    @IBOutlet var groupsView: UITableView!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataGroups.count
    }
    //реализация присвоения титулу ячеек значений элементов массива dataGroups, идентификатор CellGroups задается в Storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellGroups", for: indexPath) as! GroupsCell
        let group = dataGroups[indexPath.row]
        cell.groupsName.text = group
        let image = UIImage(named: "swift")
        cell.groupImage.image = image
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("[Logging] delete group from favorite - \(dataGroups[indexPath.row])")
            dataGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidLoad() {
        print("[Logging] load Groups View")
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let globalGView = segue.source as! GlobalSearchGroupsTableView
            //используем принудительное извлечение опционала, надо подумать как убрать этот косяк
            if let indexPath = globalGView.tableView.indexPathForSelectedRow {
                let group = globalGView.dataGlobalGroups[indexPath.row]
                if !dataGroups.contains(group) {
                    print("[Logging] add Group to favorite - \(group)")
                    dataGroups.append(group)
                    tableView.reloadData()
                }
            }
        }
    }
}

