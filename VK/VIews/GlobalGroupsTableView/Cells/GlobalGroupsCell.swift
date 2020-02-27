import UIKit

class GlobalGroupsCell: UITableViewCell {
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupsName: UILabel!
    @IBOutlet weak var groupsActivity: UILabel!
    @IBOutlet weak var groupsMembersCount: UILabel!
    
    func renderCell(model: GroupRealm) {
        
        groupsName.text = model.name
        groupsActivity.text = model.activity
        groupsMembersCount.text = String(model.membersCount)
        
        if model.activity == "" {
            groupsActivity.isHidden = true
        }
        if model.membersCount == 0 {
            groupsMembersCount.isHidden = true
        }
        
        if let url = URL(string: model.photo100) {
            groupImage.kf.setImage(with: url)
        }
    }
}
