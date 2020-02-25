import UIKit

class UserProfileInfoCell: UITableViewCell {
    
    @IBOutlet weak var statusMessage: UILabel!
    @IBOutlet weak var friendsCountButton: UIButton!
    @IBOutlet weak var subscribesCountButton: UIButton!
    @IBOutlet weak var currentCity: UILabel!
    @IBOutlet weak var placeOfWorkButton: UIButton!
    @IBOutlet weak var photoCollection: UICollectionView!
    
    
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
