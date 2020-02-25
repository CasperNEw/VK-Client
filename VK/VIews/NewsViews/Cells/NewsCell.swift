import UIKit
import Kingfisher

class NewsCell: UITableViewCell {

    @IBOutlet weak var mainAuthorImage: UIImageView!
    @IBOutlet weak var mainAuthorName: UILabel!
    @IBOutlet weak var publicationDate: UILabel!
    @IBOutlet weak var publicationText: UILabel!
    
    @IBOutlet weak var publicationLikeButton: LikeButton!
    @IBOutlet weak var publicationCommentButton: UIButton!
    @IBOutlet weak var publicationForwardButton: UIButton!
    @IBOutlet weak var publicationNumberOfViews: UIButton!
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    @IBAction func setMainLike(_ sender: Any) {
        (sender as! LikeButton).like()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainAuthorName.text = nil
        mainAuthorImage.image = nil
        publicationDate.text = nil
        self.accessoryType = .none
    }
    
    private var model = NewsRealm()
    
    func renderCell(model: NewsRealm) {
        
        mainAuthorImage.image = UIImage(named: "user_default")
        if let url = URL(string: model.authorImagePath) {
            mainAuthorImage.kf.setImage(with: url)
        }
        
        mainAuthorName.text = model.authorName
        publicationDate.text = prepareDate(modelDate: model.date)
        publicationText.text = model.text
        publicationLikeButton.likeCount = model.likes
        publicationLikeButton.liked = setUserLike(userLikes: model.userLikes)
        publicationCommentButton.setTitle(String(model.comments), for: .normal)
        publicationCommentButton.tintColor = .darkGray
        publicationForwardButton.setTitle(String(model.reposts), for: .normal)
        publicationForwardButton.tintColor = .darkGray
        publicationNumberOfViews.setTitle(prepareViews(modelViews: model.views), for: .normal)
        publicationNumberOfViews.tintColor = .darkGray
        
        if model.photos.count > 0 {
            self.model = model
            newsCollectionView.register(UINib(nibName:"NewsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SimplePhotoNews")
            newsCollectionView.reloadData()
            newsCollectionView.delegate = self
            newsCollectionView.dataSource = self
        }
        if model.photos.count == 0 {
            newsCollectionView.isHidden = true
        }
    }
    
    private func prepareDate(modelDate: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM в HH:mm"
        formatter.locale = Locale(identifier: "ru")
        let date = Date(timeIntervalSince1970: Double(modelDate))
        return formatter.string(from: date)
    }
    
    private func prepareViews(modelViews: Int) -> String {
        let count = modelViews
        if count < 1000 {
            return "\(modelViews)"
        } else if count < 10000 {
            return String(format: "%.1fK", Float(count) / 1000)
        } else {
            return String(format: "%.0fK", floorf(Float(count) / 1000))
        }
    }
    
    private func setUserLike(userLikes: Int) -> Bool {
        return userLikes == 1 ?  true : false
    }
    
}

extension NewsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimplePhotoNews", for: indexPath) as? NewsCollectionCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .clear
        
        if let url = URL(string: model.photos[indexPath.row]) {
            cell.collectionImage.kf.setImage(with: url)
        }
        
        cell.collectionImage.contentMode = .scaleAspectFill
        cell.collectionImage.layer.borderWidth = 1
        cell.collectionImage.layer.borderColor = UIColor.darkGray.cgColor
        cell.collectionImage.layer.cornerRadius = 10
        
        return cell
    }
}
