
import UIKit

private let reuseIdentifier = "Cell"

class FriendsCollectionView: UICollectionViewController {
    
    var user: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[Logging] load Friends Photo Collection View")
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollCell", for: indexPath) as! FriendsCollectionCell
        let image = UIImage(named: user!)
        cell.FriendCollectionImage.image = image
        return cell
    }
}
/*
override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellFriends", for: indexPath) as! FriendsTableViewCell
    //cell.textLabel?.text = dataFriends[indexPath.row]
    let friend = dataFriends[indexPath.row]
    cell.FriendsName.text = friend
    let image = UIImage(named: friend)
    cell.friendsImage.image = image
    return cell
}
*/
