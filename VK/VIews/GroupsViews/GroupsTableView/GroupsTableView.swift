import UIKit
import Kingfisher

class GroupsTableView: UITableViewController {
    
    var dataGroups = [GroupVK]()
    
    @IBOutlet var groupsView: UITableView!
    
    private let groupsSearchController = UISearchController(searchResultsController: nil)
    var sortedGroups = [GroupVK]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedGroups.count
    }
    //реализация присвоения титулу ячеек значений элементов массива dataGroups, идентификатор CellGroups задается в Storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellGroups", for: indexPath) as? GroupsCell else {
            return UITableViewCell()
        }
        cell.groupsName.text = sortedGroups[indexPath.row].name
        
        //используем Kingfisher для загрузки и кеширования изображений
        let url = URL(string: sortedGroups[indexPath.row].photo50)
        cell.groupImage.kf.setImage(with: url)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
        print("[Loggin] tapped - \(sortedGroups[indexPath.row].name)")
        //сделаем переключение на alert - Error! так как у нас пока нет внутренностей для групп
        let alert = UIAlertController(title: "Error", message: "Access error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("[Logging] delete group from favorite - \(sortedGroups[indexPath.row].name)")
            dataGroups.removeAll(where: {$0.name == sortedGroups[indexPath.row].name })
            sortedGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidLoad() {
        vkApi.getGroupListForUser(token: Session.instance.token, user: Session.instance.userId) { [weak self] result in
            do {
                let resultData = try result.get()
                self?.dataGroups = resultData
                self?.makeSortedGroups()
                self?.tableView.reloadData()
            } catch {
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
        addSearchController()
        
        print("[Logging] load Groups View")
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    func makeSortedGroups() {
        sortedGroups = dataGroups
    }
    func addSearchController() {
        groupsSearchController.searchResultsUpdater = self
        groupsSearchController.obscuresBackgroundDuringPresentation = false
        groupsSearchController.searchBar.placeholder = "Groups search"
        navigationItem.searchController = groupsSearchController
        definesPresentationContext = true
        
        //sortedGroups = dataGroups
    }
    //Убрал реализацию добавления группы из GlobalGroupsTableView. Добавим реализацию после обработки json для GlobalGroup.
    /*
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
    */
}

extension GroupsTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        sortedGroups = dataGroups.filter { (group) -> Bool in
            return searchText.isEmpty ? true : group.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
}
