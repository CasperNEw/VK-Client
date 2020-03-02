import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var friendsName: UILabel!
    @IBOutlet weak var cornerShadowView: CornerShadowView!
    
    
    func renderCell(model: UserRealm) {
        
        let firstName = model.firstName
        let lastName = model.lastName
        
        friendsName.text = firstName + " " + lastName
        if model.online == 1 { friendsName.text = firstName + " " + lastName + " * online" }
        if let url = URL(string: model.photo100) {
            cornerShadowView.imageView.kf.setImage(with: url)
        }
    }
}
