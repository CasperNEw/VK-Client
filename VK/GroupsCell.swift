import UIKit

class GroupsCell: UITableViewCell {

    @IBOutlet weak var GroupsName: UILabel!
    @IBOutlet weak var GroupImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
