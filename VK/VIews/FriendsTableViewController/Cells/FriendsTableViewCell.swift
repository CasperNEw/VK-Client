import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendsName: UILabel!
    @IBOutlet weak var cornerShadowView: CornerShadowView!
    
    func renderCell(model: FriendsCellModel) {
        friendsName.text = model.friendsName
        if let url = URL(string: model.cornerShadowView) {
            cornerShadowView.imageView.kf.setImage(with: url)
        }
    }
}
