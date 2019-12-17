import UIKit

private let reuseIdentifier = "Cell"

class PhotoCollectionViewCollectionViewController: UICollectionViewController {

    var cellCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionViewCell else {
                   return UICollectionViewCell()
               }
        cell.photo.image = UIImage(named: "swift")
        
        if indexPath.row > 4 {
            cell.backgroundColor = .green
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 1
        } else {
        // Configure the cell
        cell.backgroundColor = .red
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 1
        }
        
        return cell
    }
}
