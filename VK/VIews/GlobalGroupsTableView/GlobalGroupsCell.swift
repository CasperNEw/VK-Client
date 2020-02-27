import UIKit

class GlobalGroupsCell: UITableViewCell {

    @IBOutlet weak var globalGroupImage: UIImageView!
    @IBOutlet weak var globalGroupsName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
