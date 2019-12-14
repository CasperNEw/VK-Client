import UIKit

var dataGroups = [String]()

class GroupsTableView: UITableViewController {
    
    @IBOutlet var groupsView: UITableView!
    
    private let groupsSearchController = UISearchController(searchResultsController: nil)
    var sortedGroups = [String]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedGroups.count
    }
    //реализация присвоения титулу ячеек значений элементов массива dataGroups, идентификатор CellGroups задается в Storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellGroups", for: indexPath) as? GroupsCell else {
            return UITableViewCell()
        }
        cell.groupsName.text = sortedGroups[indexPath.row]
        cell.groupImage.image = UIImage(named: "swift")
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
        print(sortedGroups[indexPath.row])
        //сделаем переключение на alert - Error! так как у нас пока нет внутренностей для групп
        let alert = UIAlertController(title: "Error", message: "Access error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("[Logging] delete group from favorite - \(sortedGroups[indexPath.row])")
            dataGroups.removeAll(where: {$0 == sortedGroups[indexPath.row] })
            sortedGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidLoad() {
        addSearchController()
        print("[Logging] load Groups View")
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func addSearchController() {
        groupsSearchController.searchResultsUpdater = self
        groupsSearchController.obscuresBackgroundDuringPresentation = false
        groupsSearchController.searchBar.placeholder = "Groups search"
        navigationItem.searchController = groupsSearchController
        definesPresentationContext = true
        
        sortedGroups = dataGroups
    }
    
    @IBAction func addGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            let globalGView = segue.source as! GlobalSearchGroupsTableView
            //используем принудительное извлечение опционала, надо подумать как убрать этот косяк
            if let indexPath = globalGView.tableView.indexPathForSelectedRow {
                let group = globalGView.sortedGlobalGroups[indexPath.row]
                if !dataGroups.contains(group) {
                    print("[Logging] add Group to favorite - \(group)")
                    dataGroups.append(group)
                    sortedGroups = dataGroups
                    tableView.reloadData()
                }
            }
        }
        //так же сыпет ошибку, но зато переключается ...
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension GroupsTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        sortedGroups = dataGroups.filter { (group) -> Bool in
            return searchText.isEmpty ? true : group.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
}
