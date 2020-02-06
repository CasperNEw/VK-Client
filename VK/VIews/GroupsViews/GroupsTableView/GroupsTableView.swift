import UIKit
import Kingfisher
import RealmSwift

class GroupsTableView: UITableViewController {
    
    var vkApi = VKApi()
    var database = GroupRepository()
    var customRefreshControl = UIRefreshControl()
    
    var groupsResult: Results<GroupRealm>?
    var token: NotificationToken?
    
    @IBOutlet var groupsView: UITableView!
    
    private let groupsSearchController = UISearchController(searchResultsController: nil)
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsResult?.count ?? 0
    }
    //реализация присвоения титулу ячеек значений элементов массива dataGroups, идентификатор CellGroups задается в Storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellGroups", for: indexPath) as? GroupsCell,
              let group = groupsResult?[indexPath.row] else {
                return UITableViewCell()
        }
        cell.groupsName.text = group.name
        //используем Kingfisher для загрузки и кеширования изображений
        let url = URL(string: group.photo50)
        cell.groupImage.kf.setImage(with: url)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
        print("[Loggin] tapped - \(String(describing: groupsResult?[indexPath.row].name))")
        //сделаем переключение на alert - Error! так как у нас пока нет внутренностей для групп
        let alert = UIAlertController(title: "Error", message: "Access error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let targetForDelete = groupsResult?[indexPath.row] else { return }
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.delete(targetForDelete)
                try realm.commitWrite()
                print("[Logging] delete group from favorite - \(targetForDelete.name)")
            } catch {
                print(error)
            }
            //TODO: remove from server !
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewDidLoad() {
        
        addSearchController()
        addRefreshControl()
        
        let hideAction = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideAction)
        
        print("[Logging] load Groups View")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getGroupsFromApi()
        getGroupsFromDatabase()
    }
    
    deinit {
        token?.invalidate()
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
    }
    
    func addRefreshControl() {
        customRefreshControl.attributedTitle = NSAttributedString(string: "Refreshing ...")
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
    }
    
    @objc func refreshTable() {
        //print("[Logging] Update CoreData[GroupCD] from server")
        print("[Logging] Update Realm[GroupRealm] from server")

        getGroupsFromApi()
        getGroupsFromDatabase()
        
        self.customRefreshControl.endRefreshing()
    }
    
    func getGroupsFromApi() {
        
        vkApi.getGroupListForUser(token: Session.instance.token, version: Session.instance.version, user: Session.instance.userId) { [weak self] result in
            switch result {
            case .success(let groups):
                //записываем данные в БД Realm
                self?.database.addGroups(groups: groups)
            case .failure(let error):
                //Уведомление пользователя
                let alert = UIAlertController(title: "Error", message: "There was an error loading your data, check your network connection", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
                
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
    }
    
    func getGroupsFromDatabase() {
        do {
            groupsResult = try database.getAllGroups()
            token = groupsResult?.observe { [weak self] results in
                switch results {
                case .error(let error):
                    print(error)
                case .initial:
                    self?.tableView.reloadData()
                case let .update(_, deletions, insertions, modifications):
                    self?.tableView.beginUpdates()
                    self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .none)
                    self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .none)
                    self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .none)
                    self?.tableView.endUpdates()
                }
            }
        } catch {
            print(error)
        }
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
        
        do {
            groupsResult = searchText.isEmpty ? try database.getAllGroups() : try database.searchGroup(name: searchText)
            self.tableView.reloadData()
        } catch {
            print(error)
        }
    }
}
