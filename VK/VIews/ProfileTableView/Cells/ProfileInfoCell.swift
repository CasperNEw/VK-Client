import UIKit

class ProfileInfoCell: UITableViewCell {
    
    @IBOutlet weak var statusMessage: UILabel!
    @IBOutlet weak var friendsCountButton: UIButton!
    @IBOutlet weak var subscribesCountButton: UIButton!
    @IBOutlet weak var placeOfWorkButton: UIButton!
    @IBOutlet weak var photoCollection: UICollectionView!
    
    
    @IBAction func friendsCountButtonTapped(_ sender: Any) {
    }
    
    @IBAction func subscribesCountButtonTapped(_ sender: Any) {
    }
    
    @IBAction func placeOfWorkButtonTapped(_ sender: Any) {
    }
    
    @IBAction func detailedInformationTapped(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}