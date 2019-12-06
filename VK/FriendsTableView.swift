import UIKit

class FriendsTableView: UITableViewController {
    
    var dataFriends: [String] = ["Amancio Ortega", "Bernard Arnault", "Bill Gates", "Carlos Slim", "Jeff Bezos", "Lawrence Ellison", "Lawrence Page", "Mark Zuckerberg", "Michael Bloomberg", "Warren Buffett"]
    
    var friendsIndex = [String]()
    
    func createIndex() {
        if dataFriends.isEmpty == false {
            for names in 0..<dataFriends.count {
                friendsIndex.append(String(dataFriends[names].first!))
            }
            print("[Logging] created special indexes for scrolling")
            print(index)
        }
        
    }
    
    //реализация количества строк (ячеек) в секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        //return dataFriends.count
    }
    //реализация количества секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataFriends.count
    }
    //реализация присвоения титулу ячеек значений элементов массива data, идентификатор CellFriends задается в Storyboard
    //переписали indexPath.row на .section, так как в новой реализации у нас каждая новая ячейка рендерится в новой секции
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFriends", for: indexPath) as! FriendsTableViewCell
        let friend = dataFriends[indexPath.section]
        cell.FriendsName.text = friend
        let image = UIImage(named: friend)
        cell.CornerShadowView.imageView.image = image
        return cell
    }
    //реализация функции при нажатии на Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
        //выведем в консоль имя нажатой ячейки
        print(dataFriends[indexPath.row])
        //сделаем переключение на Collection View, со всех ячеек переключаемся на один и тот же Collection View.
        let main = UIStoryboard( name: "Main", bundle: nil)
        let vc = main.instantiateViewController(identifier: "PhotoFreindsCollection") as! FriendsCollectionView
        vc.user = dataFriends[indexPath.section]
        navigationController?.pushViewController(vc, animated: true)
    }
    //реализуем метод который возвращает названия разделов для нашего TableView
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendsIndex
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let temp = friendsIndex as NSArray
        return temp.index(of: title)
    }
    
    
    @IBOutlet var friendsTView: UITableView!
    
    override func viewDidLoad() {
        print("[Logging] load Friends View")
        createIndex()
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
 
