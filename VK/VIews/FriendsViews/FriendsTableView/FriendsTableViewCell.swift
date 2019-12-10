import UIKit

class FriendsTableViewCell: UITableViewCell {

    @IBOutlet weak var friendsName: UILabel!
    
    @IBOutlet weak var cornerShadowView: CornerShadowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
