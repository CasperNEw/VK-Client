import UIKit

class UserProfileNewsCell: UITableViewCell {
    
    @IBOutlet weak var authorImage: CornerImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var publicationDate: UILabel!
    @IBOutlet weak var publicationText: UILabel!
    
    @IBOutlet weak var newsPhotoCollection: UICollectionView!
    
    @IBOutlet weak var publicationLikeButton: LikeButton!
    @IBOutlet weak var publicationCommentButton: UIButton!
    @IBOutlet weak var publicationForwardButton: UIButton!
    @IBOutlet weak var publicationNumberOfViews: UIButton!

    
    @IBAction func publicationLikeButtonTapped(_ sender: Any) {
        (sender as! LikeButton).like()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

