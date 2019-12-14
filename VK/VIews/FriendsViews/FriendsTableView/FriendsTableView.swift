//Уверен на 100% что можно сделать всё намного изящнее ... )
//Upd^ решил продолжить со своим решением реализации SearchBar, но с использованием изящнего кода с урока ... =)

import UIKit

struct Section<T> {
    var title: String
    var items: [T]
}

class FriendsTableView: UITableViewController {
    
    var dataFriends = [User(username: "Amancio", surname: "Ortega", avatarPath: "Amancio Ortega"),
                       User(username: "Bernard", surname: "Arnault", avatarPath: "Bernard Arnault"),
                       User(username: "Bill", surname: "Gates", avatarPath: "Bill Gates"),
                       User(username: "Carlos", surname: "Slim", avatarPath: "Carlos Slim"),
                       User(username: "Jeff", surname: "Bezos", avatarPath: "Jeff Bezos"),
                       User(username: "Lawrence", surname: "Ellison", avatarPath: "Lawrence Ellison"),
                       User(username: "Lawrence", surname: "Page", avatarPath: "Lawrence Page"),
                       User(username: "Mark", surname: "Zuckerberg", avatarPath: "Mark Zuckerberg"),
                       User(username: "Michael", surname: "Bloomberg", avatarPath: "Michael Bloomberg"),
                       User(username: "Warren", surname: "Buffett", avatarPath: "Warren Buffett")]
    
    private let searchController = UISearchController(searchResultsController: nil)

    var friendsSection = [Section<User>]()
        
    override func viewDidLoad() {
        addSearchController()
        makeSortedSection()
       
        print("[Logging] load Friends View")
    }
    
    func makeSortedSection() {
        let friendsDictionary = Dictionary.init(grouping: dataFriends ) { $0.surname.prefix(1) }
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
        cell.cornerShadowView.imageView.image = UIImage(named: friendsSection[indexPath.section].items[indexPath.row].avatarPath)
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
        }) { $0.surname.prefix(1) }
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
