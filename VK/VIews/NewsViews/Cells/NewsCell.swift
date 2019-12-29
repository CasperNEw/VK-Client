import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var mainAuthorImage: UIImageView!
    @IBOutlet weak var mainAuthorName: UILabel!
    @IBOutlet weak var publicationDate: UILabel!
    @IBOutlet weak var publicationText: UILabel!
    
    
    @IBOutlet weak var secondAuthorImage: UIImageView!
    @IBOutlet weak var secondAuthorName: UILabel!
    
    
    @IBOutlet weak var publicationLikeButton: LikeButton!
    @IBOutlet weak var publicationCommentButton: UIButton!
    @IBOutlet weak var publicationForwardButton: UIButton!
    @IBOutlet weak var publicationNumberOfViews: UIButton!
    
    
    @IBOutlet weak var lastCommentAuthorImage: UIImageView!
    @IBOutlet weak var lastCommentAuthorName: UILabel!
    @IBOutlet weak var lastCommentPublicationDate: UILabel!
    @IBOutlet weak var lastCommentText: UILabel!
    @IBOutlet weak var lastCommentLikeButton: LikeButton!
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var userEmojiButton: UIButton!
    
    
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    
    @IBAction func setMainLike(_ sender: Any) {
        (sender as! LikeButton).like()
    }
    
    @IBAction func setLastCommentLike(_ sender: Any) {
        (sender as! LikeButton).like()
    }
    
    @IBAction func userEmojiButtonPush(_ sender: Any) {
        print("Вы не видите клавиатуру Emoji - а она есть ...")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    


}
