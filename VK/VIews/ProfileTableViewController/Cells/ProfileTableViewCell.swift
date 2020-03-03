import UIKit
import ImageViewer_swift

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusMessage: UILabel!
    @IBOutlet weak var friendsCountButton: UIButton!
    @IBOutlet weak var subscribesCountButton: UIButton!
    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var placeOfWorkButton: UIButton!
    @IBOutlet weak var photoCollection: UICollectionView!
    
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var friendsStackView: UIStackView!
    @IBOutlet weak var cityStackView: UIStackView!
    @IBOutlet weak var workPlaceStackView: UIStackView!
    
    private var photos = [URL]()
    
    func renderCell(model: ProfileCell) {
        
        statusMessage.text = model.statusMessage
        friendsCountButton.setTitle(model.friendsCountButton, for: .normal)
        subscribesCountButton.setTitle(model.subscribesCountButton, for: .normal)
        currentCity.text = model.currentCity
        placeOfWorkButton.setTitle(model.placeOfWorkButton, for: .normal)
        
        statusStackView.isHidden = model.statusStackViewIsEmpty
        friendsStackView.isHidden = model.friendsStackViewIsEmpty
        cityStackView.isHidden = model.cityStackViewIsEmpty
        workPlaceStackView.isHidden = model.workPlaceStackViewIsEmpty
        photoCollection.isHidden = model.photoCollectionIsEmpty
        
        if photoCollection.isHidden == false {
            self.photos = model.photoCollection
            photoCollection.register(UINib(nibName: "ProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollectionViewCell")
            photoCollection.reloadData()
            photoCollection.delegate = self
            photoCollection.dataSource = self
        }
    }
}

extension ProfileTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
        
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
