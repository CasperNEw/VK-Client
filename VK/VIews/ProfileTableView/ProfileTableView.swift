//создаем экран отображения данных пользователя, его профиль
import UIKit

class ProfileTableView: UITableViewController {
    
    var arrayIndexPath = 0
    var profileIndexPath = 0
    var newsIndexPath = 0
    var cellCount = 0
    
    var dataNews = [News(mainAvatar: "Bill Gates", mainName: "Bill Gates", mainDate: "25.12.2019", mainText: "Merry Christmas!", mainImage: ["Swift Dev 001","Swift Dev 001"], secondImage: "", secondName: "", likeCount: 330, commentCount: 0, forwardCount: 10, viewsCount: 808, lastCommentAvatar: "", lastCommentName: "", lastCommentDate: "", lastCommentText: "", lastCommentLikeCount: 0), News(mainAvatar: "Bill Gates", mainName: "Bill Gates", mainDate: "01.01.2020", mainText: "Happy New Year my dear Friends!", mainImage: ["Swift Dev 001","Swift Dev 001","Swift Dev 001","Swift Dev 001"], secondImage: "", secondName: "", likeCount: 417, commentCount: 0, forwardCount: 15, viewsCount: 909, lastCommentAvatar: "", lastCommentName: "", lastCommentDate: "", lastCommentText: "", lastCommentLikeCount: 0), News(mainAvatar: "Bill Gates", mainName: "Bill Gates", mainDate: "09.01.2020", mainText: "Ready for work! Go!", mainImage: ["Swift Dev 001"], secondImage: "", secondName: "", likeCount: 0, commentCount: 0, forwardCount: 1, viewsCount: 555, lastCommentAvatar: "", lastCommentName: "", lastCommentDate: "", lastCommentText: "", lastCommentLikeCount: 0)]
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //регистрируем ячейки
        tableView.register(UINib(nibName: "ProfileNewsCell", bundle: nil), forCellReuseIdentifier: "ProfileNews")
        tableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "ProfileInfo")
        
        profileImage.image = UIImage(named: "Bill Gates")
        
        //автоматическое изменение высоты ячейки
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataNews.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let infoCell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfo", for: indexPath) as? ProfileInfoCell else { return UITableViewCell() }
        
        infoCell.statusMessage.text = "Let's make 2020 the best year of our life!"
        infoCell.friendsCountButton.setTitle("1000001 friends", for: .normal)
        infoCell.subscribesCountButton.setTitle("500005 subscribes", for: .normal)
        infoCell.currentCity.text = "Seattle"
        infoCell.placeOfWorkButton.setTitle("Microsoft Corporation", for: .normal)
        
        infoCell.photoCollection.register(UINib(nibName: "ProfileCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollection")
        infoCell.photoCollection.delegate = self
        infoCell.photoCollection.dataSource = self
        arrayIndexPath = indexPath.row - 1

        
        guard let newsCell = tableView.dequeueReusableCell(withIdentifier: "ProfileNews", for: indexPath) as? ProfileNewsCell else { return UITableViewCell() }
        
        let specialIndex = indexPath.row - profileIndexPath
        newsIndexPath = specialIndex
        
        newsCell.authorImage.image = UIImage(named: "\(dataNews[specialIndex].mainAvatar)")
        newsCell.authorName.text = dataNews[specialIndex].mainName
        newsCell.publicationDate.text = dataNews[specialIndex].mainDate
        newsCell.publicationText.text = dataNews[specialIndex].mainText
        newsCell.publicationLikeButton.likeCount = dataNews[specialIndex].likeCount
        newsCell.publicationCommentButton.setTitle(String(dataNews[specialIndex].commentCount), for: .normal)
        newsCell.publicationCommentButton.tintColor = .darkGray
        newsCell.publicationForwardButton.setTitle(String(dataNews[specialIndex].forwardCount), for: .normal)
        newsCell.publicationForwardButton.tintColor = .darkGray
        newsCell.publicationNumberOfViews.setTitle(String(dataNews[specialIndex].viewsCount), for: .normal)
        newsCell.publicationNumberOfViews.tintColor = .darkGray
        

        newsCell.newsPhotoCollection.register(UINib(nibName: "ProfileCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollection")
        newsCell.newsPhotoCollection.delegate = self
        newsCell.newsPhotoCollection.dataSource = self
        
        if indexPath.row == 0 {
            profileIndexPath += 1
            return infoCell
        } else {
            return newsCell
        }
    }
}

extension ProfileTableView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("Logging1 - \(arrayIndexPath)")
        if arrayIndexPath == -1 {
            return 4
        } else {
            print("Logging - realy?!?!")
            print("Logging - \(dataNews[arrayIndexPath].mainImage.count)")
            return dataNews[arrayIndexPath].mainImage.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollection", for: indexPath) as? ProfileCollectionCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .clear
        print("Logging2 - \(arrayIndexPath)")
        print("Logging3 - \(newsIndexPath)")
        cellCount += 1
        if arrayIndexPath == -1 {
            cell.collectionImage.image = UIImage(named: "Bill Gates")
            print("Logging - create Cell - \(cellCount), with Bill image")
        } else {
            cell.collectionImage.image = UIImage(named: dataNews[arrayIndexPath].mainImage[indexPath.row])
            print("Logging - create Cell - \(cellCount), with other image")
        }
        
        cell.collectionImage.contentMode = .scaleAspectFill
        cell.collectionImage.layer.borderWidth = 1
        cell.collectionImage.layer.borderColor = UIColor.darkGray.cgColor
        cell.collectionImage.layer.cornerRadius = 10
        
        guard let cellTwo = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollection", for: indexPath) as? ProfileCollectionCell else { return UICollectionViewCell() }
        
        let specialIndex = indexPath.row - profileIndexPath
        
        cellTwo.backgroundColor = .clear
        //error error error !!! думай димас ... думай ...
        //cellTwo.collectionImage.image = UIImage(named: dataNews[newsIndexPath].mainImage[indexPath.row])
        
        cellTwo.collectionImage.contentMode = .scaleAspectFill
        cellTwo.collectionImage.layer.borderWidth = 1
        cellTwo.collectionImage.layer.borderColor = UIColor.darkGray.cgColor
        cellTwo.collectionImage.layer.cornerRadius = 10
        
        if arrayIndexPath == -1 {
            return cell
        } else {
            return cellTwo
        }
        //return cell
    }
}

