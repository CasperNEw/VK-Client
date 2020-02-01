import UIKit
import Kingfisher

struct Section<T> {
    var title: String
    var items: [T]
}

protocol UserListPresenter {
    func getUserList(completion: @escaping (Swift.Result<[UserVK], Error>) -> ())
    func getUsersFromDatabase() -> [UserVK]
}

class UserListPresenterImplementation: UserListPresenter {
    
    
    let vkApi: VKApi
    let database: UserCDRepository
    
    init(database: UserCDRepository, api: VKApi) {
        self.vkApi = api
        self.database = database
    }
    
    func getUserList(completion: @escaping (Swift.Result<[UserVK], Error>) -> ()) {
        vkApi.getFriendList(token: Session.instance.token, version: Session.instance.version)
        { [weak self] result in
            switch result {
            case .success(let users):
                users.forEach{ self?.database.create(entity: $0) }
                completion(.success(users))
            case .failure(let error):
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
    }
    
    func getUsersFromDatabase() -> [UserVK] {
        return database.getAll()
    }
}

var vkApi = VKApi() //общий объект, используется во всех view для запроса данных через vkApi ... позже удалить!

class FriendsTableView: UITableViewController {
    
    //по хорошему надо закинуть в отдельный класс
    var presenter = UserListPresenterImplementation(database: UserCDRepository(stack: CoreDataStack.shared), api: VKApi())
    
    //Временно добавляем экземпляр БД для теста Realm
    var database = UserRepository() // ?!?!??!?!? подумать проверить убрать коммент ...
    
    var dataFriends = [UserVK]()
    //var dataFriendsTest = [UserVK]()
    var friendsSection = [Section<UserVK>]()
    
    var customRefreshControl = UIRefreshControl()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        
        usersRequest()
        addSearchController()
        addRefreshControl()
        print("[Logging] load Friends View")
        
        /*
         //пока что на всякий случай сохраним ... =Р
         
         vkApi.getFriendList(token: Session.instance.token, version: Session.instance.version) { [weak self] result in
         do {
         let resultData = try result.get()
         self?.dataFriends = resultData
         self?.makeSortedSection()
         self?.tableView.reloadData()
         } catch {
         print("[Logging] Error retrieving the value: \(error)")
         }
         }
         */
    }
    
    func usersRequest() {
        
        //делаем проверку наличия данных в БД, если нет то делаем запрос на сервер
        if presenter.getUsersFromDatabase().count == 0 {
            //Наполняем одновременно CoreData и Realm репозитории
            presenter.getUserList { [weak self] result in
                switch result {
                case .success(let users): //modify for create DB Realm UserRealm
                    self?.database.addUsers(users: users) //create DB Realm UserRealm
                    print("[Logging] CoreData UserCD create")
                    print("[Logging] Realm UserRealm create")
                case .failure(let error):
                    print("[Logging] Error retrieving the value: \(error)")
                    
                }
            }
        }
        //получаем массив данных UserVK из БД Realm для отображения
        usersFromRealm()
        
        //если что то пошло не так и на данный момент наш массив данных пуст, цепляем все данные из CoreData
        if dataFriends.count == 0 {
            usersFromCoreData()
        }
        
        //При загрузке страницы должен принудительно совершиться api request.
        //Какое то зацикливание функций друг на друга ... подумать.
        
    }
    
    @discardableResult func usersFromRealm() -> Bool {
        do {
            self.dataFriends = Array(try database.getAllUsers()).map{ $0.toModel() }
            self.makeSortedSection()
            self.tableView.reloadData()
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func usersFromCoreData() {
        self.dataFriends = presenter.getUsersFromDatabase()
        self.makeSortedSection()
        self.tableView.reloadData()
    }
    
    func makeSortedSection() {
        let friendsDictionary = Dictionary.init(grouping: dataFriends ) { $0.lastName.prefix(1) }
        friendsSection = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendsSection.sort { $0.title < $1.title }
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
        print("[Logging] Update CoreData[UserCD] from server")
        print("[Logging] Update Realm[UserRealm] from server")
        
        presenter.getUserList { [weak self] result in
            switch result {
            case .success(let users): //modify for update DB Realm UserRealm
                self?.database.addUsers(users: users) //update DB Realm UserRealm
                self?.usersRequest()
                self?.customRefreshControl.endRefreshing()
            case .failure(let error):
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
        
    }
    
    //реализация количества строк (ячеек) в секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsSection[section].items.count
    }
    //реализация количества секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendsSection.count
    }
    //реализация присвоения титулу ячеек значений элементов массива data, идентификатор CellFriends задается в Storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellFriends", for: indexPath) as? FriendsTableViewCell else {
            return UITableViewCell()
        }
        cell.friendsName.text = friendsSection[indexPath.section].items[indexPath.row].fullname
        
        //используем Kingfisher для загрузки и кеширования изображений
        let url = URL(string: friendsSection[indexPath.section].items[indexPath.row].photo100)
        cell.cornerShadowView.imageView.kf.setImage(with: url)
        
        //cell.cornerShadowView.imageView.image = UIImage(named: friendsSection[indexPath.section].items[indexPath.row].avatarPath)
        
        return cell
    }
    //реализация функции при нажатии на Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
        //выведем в консоль имя нажатой ячейки
        print(friendsSection[indexPath.section].items[indexPath.row].fullname)
        /*
         //сделаем переключение на Collection View с пробросом данных
         let main = UIStoryboard( name: "Main", bundle: nil)
         let vc = main.instantiateViewController(identifier: "PhotoFreindsCollection") as! FriendsCollectionView
         vc.user = friendsSection[indexPath.section].items[indexPath.row].fullname
         navigationController?.pushViewController(vc, animated: true)
         */
        
        //сделаем переключение на ProfileView с пробросом данных
        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = main.instantiateViewController(identifier: "ProfileTableView") as? ProfileTableView else {
            return
        }
        vc.user = friendsSection[indexPath.section].items[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    //реализуем метод который возвращает названия разделов для нашего TableView
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsSection.map { $0.title }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendsSection[section].title
    }
    
    @IBOutlet var friendsTView: UITableView!
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension FriendsTableView: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        do {
            self.dataFriends = searchText.isEmpty ?
                Array(try database.getAllUsers()).map{ $0.toModel() } :
                Array(try database.searchusers(name: searchText)).map{ $0.toModel() }
            /*
            //В рамках текущей реализации сдесь должна быть проверка на то какую БД мы используем. То есть возможен сценарий когда dataFriends у нас != 0, но имеется проблема с БД Realm. И при инициализации страницы мы получили исходные данные из CoreData.
            
            if usersFromRealm() == false {
                self.dataFriends = searchText.isEmpty ?
                    presenter.getUsersFromDatabase() :
                    presenter.getUsersFromDatabase() //А тут должен быть страшный fetchRequest к CoreData ...
            }
            */
            let friendsDictionary = Dictionary(grouping : dataFriends) { $0.lastName.prefix(1) }
            
            friendsSection = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
            friendsSection.sort { $0.title < $1.title }
            tableView.reloadData()
        } catch {
            print(error)
        }
        
        
        /* //Старая запись, до работы с БД
        let friendsDictionary = Dictionary.init(grouping: dataFriends.filter { (user) -> Bool in
            return searchText.isEmpty ? true : user.fullname.lowercased().contains(searchText.lowercased())
        }) { $0.lastName.prefix(1) }
        //Группируем в секции
        friendsSection = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendsSection.sort { $0.title < $1.title }
        tableView.reloadData()
        */
    }
}


//Реализация поиска при добавлении searchBar через Storyboard

//@IBOutlet ...

//extension FriendsTableView: UISearchBarDelegate {
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let friendsDictionary = Dictionary.init(grouping: dataFriends.filter { (user) -> Bool in
//            return searchText.isEmpty ? true : user.fullname.lowercased().contains(searchText.lowercased())
//        }) { $0.surname.prefix(1) }
//        friendsSection = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
//        friendsSection.sort { $0.title < $1.title }
//        tableView.reloadData()
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        view.endEditing(true)
//    }
//}
