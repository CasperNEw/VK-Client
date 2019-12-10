//Уверен на 100% что можно сделать всё намного изящнее ... )

import UIKit

struct Section<T> {
    var title: String
    var items: [T]
}

class FriendsTableView: UITableViewController {
    
    var dataFriends = [User(username: "Amancio Ortega", avatarPath: "Amancio Ortega"),
                       User(username: "Bernard Arnault", avatarPath: "Bernard Arnault"),
                       User(username: "Bill Gates", avatarPath: "Bill Gates"),
                       User(username: "Carlos Slim", avatarPath: "Carlos Slim"),
                       User(username: "Jeff Bezos", avatarPath: "Jeff Bezos"),
                       User(username: "Lawrence Ellison", avatarPath: "Lawrence Ellison"),
                       User(username: "Lawrence Page", avatarPath: "Lawrence Page"),
                       User(username: "Mark Zuckerberg", avatarPath: "Mark Zuckerberg"),
                       User(username: "Michael Bloomberg", avatarPath: "Michael Bloomberg"),
                       User(username: "Warren Buffett", avatarPath: "Warren Buffett")]
    
    private var filteredDataFriends = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var friendsSection = [Section<User>]()
    var friendsSectionTwo = [Section<User>]()
        
    override func viewDidLoad() {
        //search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //формирование элементов разделов для быстрого перемещения по TableView
        let friendsDictionary = Dictionary.init(grouping: dataFriends ) {
            $0.username.prefix(1)
        }
        friendsSection = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendsSection.sort { $0.title < $1.title }
        print("[Logging] load Friends View")
    }
    
    //реализация количества строк (ячеек) в секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //тестирование, searchBar
        if isFiltering {
            return friendsSectionTwo[section].items.count
        }
        return friendsSection[section].items.count
    }
    //реализация количества секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return friendsSectionTwo.count
        } 
        return friendsSection.count
    }
    //реализация присвоения титулу ячеек значений элементов массива data, идентификатор CellFriends задается в Storyboard
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellFriends", for: indexPath) as? FriendsTableViewCell else {
            return UITableViewCell()
        }
        //тестирование, searchBar
        if isFiltering {
            cell.friendsName.text = friendsSectionTwo[indexPath.section].items[indexPath.row].username
            cell.cornerShadowView.imageView.image = UIImage(named: friendsSectionTwo[indexPath.section].items[indexPath.row].avatarPath)
            return cell
        }
        cell.friendsName.text = friendsSection[indexPath.section].items[indexPath.row].username
        cell.cornerShadowView.imageView.image = UIImage(named: friendsSection[indexPath.section].items[indexPath.row].avatarPath)
        return cell
    }
    //реализация функции при нажатии на Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
        //выведем в консоль имя нажатой ячейки
        if isFiltering {
            print(friendsSectionTwo[indexPath.section].items[indexPath.row].username)
            //сделаем переключение на Collection View
            let main = UIStoryboard( name: "Main", bundle: nil)
            let vc = main.instantiateViewController(identifier: "PhotoFreindsCollection") as! FriendsCollectionView
            vc.user = friendsSectionTwo[indexPath.section].items[indexPath.row].username
            navigationController?.pushViewController(vc, animated: true)
        } else {
        print(friendsSection[indexPath.section].items[indexPath.row].username)
        //сделаем переключение на Collection View
        let main = UIStoryboard( name: "Main", bundle: nil)
        let vc = main.instantiateViewController(identifier: "PhotoFreindsCollection") as! FriendsCollectionView
        vc.user = friendsSection[indexPath.section].items[indexPath.row].username
        navigationController?.pushViewController(vc, animated: true)
        }
    }
    //реализуем метод который возвращает названия разделов для нашего TableView
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isFiltering {
            return friendsSectionTwo.map { $0.title }
        }
        return friendsSection.map { $0.title }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering {
            return friendsSectionTwo[section].title
        }
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
        filteredDataFriends = dataFriends.filter({ (friend: User) -> Bool in
            return friend.username.lowercased().contains(searchText.lowercased())
        })
        let friendsDictionaryTwo = Dictionary.init(grouping: filteredDataFriends ) {
            $0.username.prefix(1)
        }
        friendsSectionTwo = friendsDictionaryTwo.map { Section(title: String($0.key), items: $0.value) }
        friendsSectionTwo.sort { $0.title < $1.title }
        tableView.reloadData()
    }
    
}
