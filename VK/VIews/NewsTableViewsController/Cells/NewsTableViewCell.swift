import UIKit
import Kingfisher
import ImageViewer_swift

class NewsTableViewCell: UITableViewCell {

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
        mainAuthorImage.image = UIImage(named: "user_default")
        mainAuthorName.text = nil
        publicationDate.text = nil
        self.accessoryType = .none
    }
    
    private var photos = [URL]()
    
    func renderCell(model: NewsCell) {
        
        if let url = URL(string: model.mainAuthorImage) {
            mainAuthorImage.kf.setImage(with: url)
        }
        mainAuthorName.text = model.mainAuthorName
        publicationDate.text = model.publicationDate
        publicationText.text = model.publicationText
        publicationLikeButton.likeCount = model.publicationLikeButtonCount
        publicationLikeButton.liked = model.publicationLikeButtonStatus
        publicationCommentButton.setTitle(model.publicationCommentButton, for: .normal)
        publicationCommentButton.tintColor = .darkGray
        publicationForwardButton.setTitle(model.publicationForwardButton, for: .normal)
        publicationForwardButton.tintColor = .darkGray
        publicationNumberOfViews.setTitle(model.publicationNumberOfViews, for: .normal)
        publicationNumberOfViews.tintColor = .darkGray
        newsCollectionView.isHidden = model.newsCollectionViewIsEmpty
        
        if newsCollectionView.isHidden == false {
            self.photos = model.photoCollection
            newsCollectionView.register(UINib(nibName:"NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewsCollectionViewCell")
            newsCollectionView.reloadData()
            newsCollectionView.delegate = self
            newsCollectionView.dataSource = self
        }
    }
}

extension NewsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCollectionViewCell", for: indexPath) as? NewsCollectionViewCell else { return UICollectionViewCell() }
        
        cell.backgroundColor = .clear
        cell.collectionImage.kf.setImage(with: photos[indexPath.row])
        
        // Setup Image Viewer with [URL]
        let config = UIImage.SymbolConfiguration(pointSize: UIFont.systemFontSize, weight: .bold, scale: .large)
        if let image = UIImage(systemName: "chevron.left", withConfiguration: config) {
            let newImage = image.withTintColor(.darkGray, renderingMode: .alwaysOriginal)
            let options: [ImageViewerOption] = [.closeIcon(newImage)]
            cell.collectionImage.setupImageViewer(urls: photos, initialIndex: indexPath.row, options: options)
        } else {
            cell.collectionImage.setupImageViewer(urls: photos, initialIndex: indexPath.row)
        }
        
        cell.collectionImage.contentMode = .scaleAspectFill
        cell.collectionImage.layer.borderWidth = 1
        cell.collectionImage.layer.borderColor = UIColor.darkGray.cgColor
        cell.collectionImage.layer.cornerRadius = 10
        
        return cell
    }
}
