import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var FriendsName: UILabel!
    
    @IBOutlet weak var friendsImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
