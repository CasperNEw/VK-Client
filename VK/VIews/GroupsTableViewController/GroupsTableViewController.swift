import UIKit

protocol GroupsTableViewControllerUpdater: AnyObject {
    func showConnectionAlert()
    func reloadTable()
    func updateTable(forDel: [Int], forIns: [Int], forMod: [Int])
    func endRefreshing()
}

class GroupsTableViewController: UITableViewController {
    
    @IBOutlet var groupsView: UITableView!
    private var presenter: GroupsPresenter?
    private var customRefreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        presenter = GroupsPresenterImplementation(view: self)
        addSearchController()
        addRefreshControl()
        print("[Logging] load Groups View")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRowsInSection(section: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupsTableViewCell", for: indexPath) as? GroupsTableViewCell, let model = presenter?.getModelAtIndex(indexPath: indexPath) else { return UITableViewCell() }
        
        cell.renderCell(model: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let main = UIStoryboard(name: "Profile", bundle: nil)
        guard let vc = main.instantiateViewController(identifier: "ProfileTableViewController") as? ProfileTableViewController else {
            return
        }
        vc.fromVC = presenter?.sendToNextVC(indexPath: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deleteEntity(indexPath: indexPath)
        }
    }
    
    private func addSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Groups search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func addRefreshControl() {
        customRefreshControl.attributedTitle = NSAttributedString(string: "Refreshing ...")
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
    }
    
    @objc private func refreshTable() {
        print("[Logging] Update Realm[GroupRealm] from server")
        
        //обнуляю строку поиска для корректного отображения
        searchController.searchBar.text = nil
        searchController.isActive = false
        
        presenter?.viewDidLoad()
    }
}

extension GroupsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        presenter?.filterContent(searchText: searchText)
    }
}

extension GroupsTableViewController: GroupsTableViewControllerUpdater {
    
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
    
    func endRefreshing() {
        self.customRefreshControl.endRefreshing()
    }
}
