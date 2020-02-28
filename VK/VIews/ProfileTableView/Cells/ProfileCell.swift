import UIKit

class ProfileCell: UITableViewCell {
    
    @IBOutlet weak var statusMessage: UILabel!
    @IBOutlet weak var friendsCountButton: UIButton!
    @IBOutlet weak var subscribesCountButton: UIButton!
    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var placeOfWorkButton: UIButton!
    @IBOutlet weak var photoCollection: UICollectionView!
    private var count = 0
    
    
    @IBAction func friendsCountButtonTapped(_ sender: Any) {
        print("friendsCountButtonTapped")
    }
    
    @IBAction func subscribesCountButtonTapped(_ sender: Any) {
        print("subscribesCountButtonTapped")
    }
    
    @IBAction func placeOfWorkButtonTapped(_ sender: Any) {
        print("placeOfWorkButtonTapped")
    }
    
    @IBAction func detailedInformationTapped(_ sender: Any) {
        print("detailedInformationTapped")
    }
    
    @IBOutlet weak var statusStackView: UIStackView!
    @IBOutlet weak var friendsStackView: UIStackView!
    @IBOutlet weak var cityStackView: UIStackView!
    @IBOutlet weak var workPlaceStackView: UIStackView!
    
    private var model = ProfileRealm()
    
    func renderCell(model: ProfileRealm) {
        
        statusMessage.text = model.status
        friendsCountButton.setTitle(prepare(modelCount: model.friendsCount) + " * " + prepare(modelCount: model.mutualFriendsCount), for: .normal)
        if model.mutualFriendsCount == 0 {
            friendsCountButton.setTitle(prepare(modelCount: model.friendsCount), for: .normal)
        }
        subscribesCountButton.setTitle(prepare(modelCount: model.followersCount), for: .normal)
        currentCity.text = model.city
        placeOfWorkButton.setTitle(model.career, for: .normal)
        
        if model.status == "" { statusStackView.isHidden = true }
        if model.friendsCount == 0 { friendsStackView.isHidden = true }
        if model.city == "" { cityStackView.isHidden = true }
        if model.career == "" { workPlaceStackView.isHidden = true }
        
        if model.photos.count > 0 {
            self.model = model
            photoCollection.register(UINib(nibName: "ProfileCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ProfileCollectionCell")
            photoCollection.reloadData()
            photoCollection.delegate = self
            photoCollection.dataSource = self
        }
        if model.photos.count == 0 {
            photoCollection.isHidden = true
        }
    }
    
    private func prepare(modelCount: Int) -> String {
           let count = modelCount
           if count < 1000 {
               return "\(modelCount)"
           } else if count < 10000 {
               return String(format: "%.1fK", Float(count) / 1000)
           } else {
               return String(format: "%.0fK", floorf(Float(count) / 1000))
           }
       }
}

extension ProfileCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionCell", for: indexPath) as? ProfileCollectionCell else { return UICollectionViewCell() }
        
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
