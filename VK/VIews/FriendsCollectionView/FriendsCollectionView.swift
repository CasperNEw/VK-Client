
import UIKit

private let reuseIdentifier = "Cell"

class FriendsCollectionView: UICollectionViewController {
    
    var user: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[Logging] load \(user ?? "Friends") Photo Collection View")
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollCell", for: indexPath) as? FriendsCollectionCell else {
            return UICollectionViewCell()
        }
        let image = UIImage(named: user!)
        cell.friendCollectionImage.image = image
        cell.friendCollectionImage.layer.cornerRadius = 10
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sectionView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterLike", for: indexPath) as? FooterWithLike else {
            return UICollectionReusableView()
        }
        return sectionView
    }
}
