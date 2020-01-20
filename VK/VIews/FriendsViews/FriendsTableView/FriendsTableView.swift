import UIKit
import Kingfisher

struct Section<T> {
    var title: String
    var items: [T]
}

var vkApi = VKApi()

class FriendsTableView: UITableViewController {
    
    var dataFriends = [UserVK]()
    var friendsSection = [Section<UserVK>]()
    
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        
        vkApi.getFriendList(token: Session.instance.token) { [weak self] dataFriends in
            self?.dataFriends = dataFriends
            self?.makeSortedSection()
            self?.tableView.reloadData()
        }
        
        addSearchController()
        //makeSortedSection()
       
        print("[Logging] load Friends View")
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
        let url = URL(string: friendsSection[indexPath.section].items[indexPath.row].photo50)
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
        //сделаем переключение на Collection View с пробросом данных
        let main = UIStoryboard( name: "Main", bundle: nil)
        let vc = main.instantiateViewController(identifier: "PhotoFreindsCollection") as! FriendsCollectionView
        vc.user = friendsSection[indexPath.section].items[indexPath.row].fullname
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
        let friendsDictionary = Dictionary.init(grouping: dataFriends.filter { (user) -> Bool in
            return searchText.isEmpty ? true : user.fullname.lowercased().contains(searchText.lowercased())
        }) { $0.lastName.prefix(1) }
        friendsSection = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendsSection.sort { $0.title < $1.title }
        tableView.reloadData()
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
