import UIKit

protocol GlobalGroupsTableViewUpdater: AnyObject {
    func showConnectionAlert()
    func reloadTable()
    func updateTable(forDel: [Int], forIns: [Int], forMod: [Int])
}

class GlobalGroupsTableView: UITableViewController {


    var presenter: GlobalGroupsPresenter?
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        presenter = GlobalGroupsPresenterImplementation(database: GlobalGroupRepository(), view: self)
        addSearchController()
        print("[Logging] load Global Groups View")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRowsInSection(section: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GlobalGroupsCell", for: indexPath) as? GlobalGroupsCell, let model = presenter?.getModelAtIndex(indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        cell.renderCell(model: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //presenter?.deleteEntity(indexPath: indexPath)
        }
    }
    
    // TODO: viewDidUnload realm.deleteAll()

    func addSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Groups search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension GlobalGroupsTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        presenter?.searchGroupsFromApi(name: searchText)
    }
}

extension GlobalGroupsTableView {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        if deltaOffset < 800.0 {
            if let searchText = searchController.searchBar.text {
                presenter?.uploadFromApi(name: searchText)
            }
        }
    }
}


extension GlobalGroupsTableView: GlobalGroupsTableViewUpdater {
    
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
