import UIKit

var dataGroups: [String] = ["Group_One", "Group_Two", "Group_Three", "Group_Four", "Group_Five"]

class GroupsTableView: UITableViewController {
    
    @IBOutlet var GroupsView: UITableView!
    
    //на всякий случай оставил штатный метод, хотя как я понял он у меня просто вписан в метод tableView
    //но пока оставим, вдруг придется переделать в дальнейшем
    //override func numberOfSections(in tableView: UITableView) -> Int {
    //    return 0
    //}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataGroups.count
        }
        //реализация присвоения титулу ячеек значений элементов массива dataGroups, идентификатор CellGroups задается в Storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellGroups", for: indexPath)
            cell.textLabel?.text = dataGroups[indexPath.row]
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
        
        override func viewDidLoad() {
            print("[Logging] load Groups View")
        }
        @objc func hideKeyboard() {
            view.endEditing(true)
        }
    }

