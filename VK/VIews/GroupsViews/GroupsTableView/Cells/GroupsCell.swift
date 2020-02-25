import UIKit

class GroupsCell: UITableViewCell {

    @IBOutlet weak var groupsName: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    
    func renderCell(model: GroupRealm) {
        
        groupsName.text = model.name
        
        if let url = URL(string: model.photo100) {
            groupImage.kf.setImage(with: url)
        }
    }
}
