import UIKit

protocol NewsTableViewControllerUpdater: AnyObject {
    func showConnectionAlert()
    func reloadTable()
    func updateTable(forDel: [Int], forIns: [Int], forMod: [Int])
    func endRefreshing()
}

class NewsTableViewController: UITableViewController {
    
    private var presenter: NewsPresenter?
    private var customRefreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        presenter = NewsPresenterImplementation(view: self)
        addSearchController()
        addRefreshControl()
        setupTableForSmoothScroll()
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        
        //автоматическое изменение высоты ячейки
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRowsInSection(section: section) ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell, let model = presenter?.getModelAtIndex(indexPath: indexPath) else { return UITableViewCell()
        }
        
        cell.renderCell(model: model)
        return cell
    }
    
    private func addSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "News search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func addRefreshControl() {
        customRefreshControl.attributedTitle = NSAttributedString(string: "Refreshing ...")
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
    }
    
    @objc private func refreshTable() {
        print("[Logging] Update Realm[NewsRealm] from server")
        
        //обнуляю строку поиска для корректного отображения
        searchController.searchBar.text = nil
        searchController.isActive = false
        
        presenter?.viewDidLoad()
    }
    
    private func setupTableForSmoothScroll() {
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
    }
}

extension NewsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        presenter?.filterContent(searchText: searchText)
    }
}

extension NewsTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset < 800.0, searchController.isActive == false {
            presenter?.uploadData()
        }
    }
}

extension NewsTableViewController: NewsTableViewControllerUpdater {
    
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
        
        let alert = UIAlertController(title: "Error", message: "An error occurred while loading the data, check the network connection, if this error appears again, please restart the application", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func endRefreshing() {
        self.customRefreshControl.endRefreshing()
    }
}
