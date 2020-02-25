import UIKit

protocol GroupsTableViewUpdater: AnyObject {
    func showConnectionAlert()
    func reloadTable()
    func updateTable(forDel: [Int], forIns: [Int], forMod: [Int])
}

class GroupsTableView: UITableViewController {
    
    @IBOutlet var groupsView: UITableView!
    var presenter: GroupsPresenter?
    var customRefreshControl = UIRefreshControl()
    private let groupsSearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        presenter = GroupsPresenterImplementation(database: GroupRepository(), view: self)
        addSearchController()
        addRefreshControl()
        print("[Logging] load Groups View")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.loadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRowsInSection(section: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellGroups", for: indexPath) as? GroupsCell, let model = presenter?.getModelAtIndex(indexPath: indexPath) else { return UITableViewCell()
        }
        cell.renderCell(model: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteEntity(indexPath: indexPath)
        }
    }
    
    func addSearchController() {
        groupsSearchController.searchResultsUpdater = self
        groupsSearchController.obscuresBackgroundDuringPresentation = false
        groupsSearchController.searchBar.placeholder = "Groups search"
        navigationItem.searchController = groupsSearchController
        definesPresentationContext = true
    }
    
    func addRefreshControl() {
        customRefreshControl.attributedTitle = NSAttributedString(string: "Refreshing ...")
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
    }
    
    @objc func refreshTable() {
        //print("[Logging] Update CoreData[GroupCD] from server")
        print("[Logging] Update Realm[GroupRealm] from server")
        
        //обнуляю строку поиска для корректного отображения
        groupsSearchController.searchBar.text = nil
        groupsSearchController.isActive = false
        
        presenter?.loadData()
        self.customRefreshControl.endRefreshing()
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
        presenter?.searchGroups(name: searchText)
    }
}

extension GroupsTableView: GroupsTableViewUpdater {
    
    func updateTable(forDel: [Int], forIns: [Int], forMod: [Int]) {
        
        tableView.beginUpdates()
        tableView.deleteRows(at: forDel.map { IndexPath(row: $0, section: 0) }, with: .none)
        tableView.insertRows(at: forIns.map { IndexPath(row: $0, section: 0) }, with: .none)
        tableView.reloadRows(at: forMod.map { IndexPath(row: $0, section: 0) }, with: .none)
        tableView.endUpdates()
        
    }
    
    func reloadTable() {
        tableView.reloadData()
        
    }
    
    func showConnectionAlert() {
        let alert = UIAlertController(title: "Error", message: "There was an error loading your data, check your network connection", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
