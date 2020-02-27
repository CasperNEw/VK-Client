import UIKit


class GlobalSearchGroupsTableView: UITableViewController {

    var dataGlobalGroups: [String] = ["iOS Development Course", "Objective-C, Swift, Cocoa & iOS Developers, tvOS", "Школа Брата Антония", "The Swift Developers" , "Swiftbook.ru", "loftblog", "LearningIT", "Sergey Kargopolov", "ITVDN", "Alex Skutarenko", "Swift Lessons RU", "learnSwift.ru", "Гоша Дударь"]

    var sortedGlobalGroups = [String]()
    var customRefreshControl = UIRefreshControl()
    
    @IBOutlet var globalSearchGroupView: UITableView!
    
    private let gGroupsSearchController = UISearchController(searchResultsController: nil)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedGlobalGroups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellGlobalGroups", for: indexPath) as? GlobalGroupsCell else {
            return UITableViewCell()
        }
        cell.globalGroupsName.text = sortedGlobalGroups[indexPath.row]
        cell.globalGroupImage.image = UIImage(named: "swift")
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
        //выведем в консоль имя нажатой ячейки
        print(sortedGlobalGroups[indexPath.row])
    }

    override func viewDidLoad() {
        addSearchController()
        addRefreshControl()
        print("[Logging] load Global Search Groups View")
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func addSearchController() {
        gGroupsSearchController.searchResultsUpdater = self
        gGroupsSearchController.obscuresBackgroundDuringPresentation = false
        gGroupsSearchController.searchBar.placeholder = "Groups search"
        navigationItem.searchController = gGroupsSearchController
        definesPresentationContext = true
        
        sortedGlobalGroups = dataGlobalGroups
    }
    func addRefreshControl() {
        customRefreshControl.attributedTitle = NSAttributedString(string: "Refreshing ...")
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
    }
    @objc func refreshTable() {
        print("[Logging] Update Global Groups from server")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.customRefreshControl.endRefreshing()
        }
    }
}

extension GlobalSearchGroupsTableView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        sortedGlobalGroups = dataGlobalGroups.filter { (group) -> Bool in
            return searchText.isEmpty ? true : group.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
    
}
