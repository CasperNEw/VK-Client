import Foundation
import RealmSwift

class UserRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var isClosed = false
    @objc dynamic var canAccessClosed = true
    @objc dynamic var photo100 = ""
    @objc dynamic var online = 0
    @objc dynamic var deactivated = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["firstName", "lastName"]
    }
    
    var groups = List<GroupRealm>()
    
    func toModel() -> UserVK {
        return UserVK(id: id, firstName: firstName, lastName: lastName, isClosed: isClosed, canAccessClosed: canAccessClosed, photo100: photo100, online: online, deactivated: deactivated)
    }
}
