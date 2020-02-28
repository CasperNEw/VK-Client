import UIKit

protocol FriendsTableViewUpdater: class {
    func updateTable()
}

class FriendsTableView: UITableViewController {
    
    @IBOutlet var friendsTView: UITableView!
    var presenter: FriendsPresenter?
    var customRefreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        //так как мы переходим внутри TBar, то пока не можем реализовать конфигуратор
        //configurator?.configure(view: self)
        presenter = FriendsPresenterImplementation(database: UserRepository(), view: self)
        
        presenter?.viewDidLoad()
        addSearchController()
        addRefreshControl()
        print("[Logging] load Friends View")
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return presenter?.getSectionIndexTitles()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.getTitleForSection(section: section)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.getNumberOfSections() ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRowsInSection(section: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellFriends", for: indexPath) as? FriendsTableViewCell, let model = presenter?.getModelAtIndex(indexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.renderCell(model: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
 
        //сделаем переключение на ProfileView с пробросом данных
        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = main.instantiateViewController(identifier: "ProfileTableView") as? ProfileTableView else {
            return
        }
        vc.fromVC = presenter?.sendToNextVC(indexPath: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Friends search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func addRefreshControl() {
        customRefreshControl.attributedTitle = NSAttributedString(string: "Refreshing ...")
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
    }
    
    @objc func refreshTable() {
        //print("[Logging] Update CoreData[UserCD] from server")
        print("[Logging] Update Realm[UserRealm] from server")
        self.presenter?.apiRequest()
        self.customRefreshControl.endRefreshing()
    }
}

extension FriendsTableView: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        presenter?.searchFriends(name: searchText)
        tableView.reloadData()
    }
}

extension FriendsTableView: FriendsTableViewUpdater {
    func updateTable() {
        tableView.reloadData()
    }
}
