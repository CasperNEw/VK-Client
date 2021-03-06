import UIKit

protocol GlobalGroupsTableViewControllerUpdater: AnyObject {
    func showConnectionAlert()
    func reloadTable()
    func updateTable(forDel: [Int], forIns: [Int], forMod: [Int])
}

class GlobalGroupsTableViewController: UITableViewController {

    private var presenter: GlobalGroupsPresenter?
    private let searchController = UISearchController(searchResultsController: nil)
    private let globalGroupsCellName = String(describing: GlobalGroupsTableViewCell.self)
    
    override func viewDidLoad() {
        presenter = GlobalGroupsPresenterImplementation(view: self)
        addSearchController()
        updateNavigationItem()
        print("[Logging] load Global Groups View")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.viewDidAppear(searchControllerIsActive: searchController.isActive)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRowsInSection(section: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: globalGroupsCellName, for: indexPath) as? GlobalGroupsTableViewCell, let model = presenter?.getModelAtIndex(indexPath: indexPath) else {
            return UITableViewCell()
        }
        
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
    
    private func addSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Global search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func updateNavigationItem() {
        navigationController?.navigationBar.tintColor = .darkGray
    }
}

extension GlobalGroupsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        presenter?.filterContent(searchText: searchText)
    }
}

extension GlobalGroupsTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        if deltaOffset < 800.0 {
            if let searchText = searchController.searchBar.text {
                presenter?.uploadContent(searchText: searchText)
            }
        }
    }
}

extension GlobalGroupsTableViewController: GlobalGroupsTableViewControllerUpdater {
    
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
