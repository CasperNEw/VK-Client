import Foundation
import RealmSwift

class ProfileRealm: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var online = 0
    @objc dynamic var lastSeenTime = 0
    @objc dynamic var lastSeenPlatform = 0
    @objc dynamic var status = ""
    @objc dynamic var friendsCount = 0
    @objc dynamic var mutualFriendsCount = 0
    @objc dynamic var followersCount = 0
    @objc dynamic var city = ""
    @objc dynamic var career = ""
    
    @objc dynamic var photoPath = ""
    @objc dynamic var photoWidth = 0.0
    @objc dynamic var photoHeight = 0.0
    @objc dynamic var photoRectX1 = 0.0
    @objc dynamic var photoRectY1 = 0.0
    @objc dynamic var photoRectX2 = 0.0
    @objc dynamic var photoRectY2 = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var photos = List<String>()
    
    func toModel() -> ProfileVK {

    var photosToModel = [String]()
    photos.forEach { photosToModel.append($0) }
        
        return ProfileVK(id: id, firstName: firstName, lastName: lastName, online: online, lastSeenTime: lastSeenTime, lastSeenPlatform: lastSeenPlatform, status: status, friendsCount: friendsCount, mutualFriendsCount: mutualFriendsCount, followersCount: followersCount, city: city, career: career, photoPath: photoPath, photoWidth: photoWidth, photoHeight: photoHeight, photoRectX1: photoRectX1, photoRectY1: photoRectY1, photoRectX2: photoRectX2, photoRectY2: photoRectY2, photos: photosToModel)
    }
}
