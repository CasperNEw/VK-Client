import UIKit

class GroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupsName: UILabel!
    @IBOutlet weak var groupsActivity: UILabel!
    @IBOutlet weak var groupsMembersCount: UILabel!
    
    func renderCell(model: GroupsCell) {
        
        if let url = URL(string: model.groupImage) {
            groupImage.kf.setImage(with: url)
        }
        groupsName.text = model.groupsName
        groupsActivity.text = model.groupsActivity
        groupsMembersCount.text = model.groupsMembersCount
        groupsActivity.isHidden = model.groupsActivityIsHidden
        groupsMembersCount.isHidden = model.groupsMembersCountIsHidden
    }
}
