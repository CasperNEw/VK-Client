import UIKit

class NewsTableView: UITableViewController {
    
    var arrayIndexPath = 0
    
    var dataNews = [News(mainAvatar: "AI", mainName: "Apple Insider", mainDate: "13.11.2019", mainText: "Представляем вашему вниманию нашу новую модель MacBook Pro 16.", mainImage: ["Swift Dev 001","Swift Dev 001","Swift Dev 001","Swift Dev 001","Swift Dev 001","Swift Dev 001","Swift Dev 001","Swift Dev 001","Swift Dev 001"], secondImage: "Tim Cook", secondName: "Tim Cook", likeCount: 500, commentCount: 45, forwardCount: 10, viewsCount: 800, lastCommentAvatar: "swift", lastCommentName: "Anonymous", lastCommentDate: "18.12.2019", lastCommentText: "Очередная попытка Apple сделать нормально?", lastCommentLikeCount: 33), News(mainAvatar: "AI", mainName: "Apple Insider", mainDate: "15.11.2019", mainText: "Apple вернулась к своей старой клавиатуре, ножницы.", mainImage: ["Swift Dev 001","Swift Dev 001","Swift Dev 001"], secondImage: "Tim Cook", secondName: "Tim Cook", likeCount: 300, commentCount: 15, forwardCount: 5, viewsCount: 500, lastCommentAvatar: "swift", lastCommentName: "Anonymous", lastCommentDate: "14.12.2019", lastCommentText: "Непонятно конечно зачем надо было так долго мучиться с этой бабочкой ...", lastCommentLikeCount: 22), News(mainAvatar: "AI", mainName: "Apple Insider", mainDate: "17.11.2019", mainText: "Apple выпустила самый большой ноутбук!.", mainImage: ["Swift Dev 001"], secondImage: "Tim Cook", secondName: "Tim Cook", likeCount: 303, commentCount: 45, forwardCount: 17, viewsCount: 430, lastCommentAvatar: "swift", lastCommentName: "Anonymous", lastCommentDate: "15.12.2019", lastCommentText: "Осталось теперь дождаться выхода 17 дюймового MacBook Pro! =)", lastCommentLikeCount: 22)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "SimpleNews")
        
        //автоматическое изменение высоты ячейки
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        
        // реализация метода появления и исчезновения клавиатуры
        let hideAction = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideAction)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //плавная анимация исчезновения выделения
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataNews.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleNews", for: indexPath) as? NewsCell
            else { return UITableViewCell() }
        
        cell.mainAuthorImage.image = UIImage(named: "\(dataNews[indexPath.row].mainAvatar)")
        cell.mainAuthorName.text = dataNews[indexPath.row].mainName
        cell.publicationDate.text = dataNews[indexPath.row].mainDate
        cell.publicationText.text = dataNews[indexPath.row].mainText
        
        cell.secondAuthorImage.image = UIImage(named: "\(dataNews[indexPath.row].secondImage)")
        cell.secondAuthorName.text = dataNews[indexPath.row].secondName
        
        cell.lastCommentAuthorImage.image = UIImage(named: "\(dataNews[indexPath.row].lastCommentAvatar)")
        cell.lastCommentAuthorName.text = dataNews[indexPath.row].lastCommentName
        cell.lastCommentPublicationDate.text = dataNews[indexPath.row].lastCommentDate
        cell.lastCommentText.text = dataNews[indexPath.row].lastCommentText
        
        cell.publicationLikeButton.likeCount = dataNews[indexPath.row].likeCount
        cell.publicationCommentButton.setTitle(String(dataNews[indexPath.row].commentCount), for: .normal)
        cell.publicationCommentButton.tintColor = .darkGray
        cell.publicationForwardButton.setTitle(String(dataNews[indexPath.row].forwardCount), for: .normal)
        cell.publicationForwardButton.tintColor = .darkGray
        cell.publicationNumberOfViews.setTitle(String(dataNews[indexPath.row].viewsCount), for: .normal)
        cell.publicationNumberOfViews.tintColor = .darkGray
        
        cell.lastCommentLikeButton.likeCount = dataNews[indexPath.row].lastCommentLikeCount
        cell.lastCommentLikeButton.tintColor = .darkGray
        cell.userEmojiButton.tintColor = .darkGray
 
        //регестрирую ячейку внутри CollectionView, который "отрисовывается" внутри текущей ячейки TableView
        cell.newsCollectionView.register(UINib(nibName: "NewsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SimplePhotoNews")
        cell.newsCollectionView.delegate = self
        cell.newsCollectionView.dataSource = self
        
        //получаем номер текущего элемента
        arrayIndexPath = indexPath.row
        
        return cell
    }
}

extension NewsTableView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataNews[arrayIndexPath].mainImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimplePhotoNews", for: indexPath) as? NewsCollectionCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .clear
        cell.collectionImage.image = UIImage(named: dataNews[arrayIndexPath].mainImage[indexPath.row])
        cell.collectionImage.contentMode = .scaleAspectFill
        cell.collectionImage.layer.borderWidth = 1
        cell.collectionImage.layer.borderColor = UIColor.darkGray.cgColor
        cell.collectionImage.layer.cornerRadius = 10
        
        return cell
    }
}
