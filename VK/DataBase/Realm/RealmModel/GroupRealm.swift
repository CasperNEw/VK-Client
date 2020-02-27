import Foundation
import RealmSwift

class GroupRealm: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var screenName = ""
    @objc dynamic var isClosed = 0
    @objc dynamic var type = ""
    @objc dynamic var isAdmin = 0
    @objc dynamic var isMember = 0
    @objc dynamic var isAdvertiser = 0
    @objc dynamic var activity = ""
    @objc dynamic var membersCount = 0
    @objc dynamic var photo100 = ""
    @objc dynamic var adminLevel = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["name"]
    }
    
    func toModel() -> GroupVK {
        
        return GroupVK(id: id, name: name, screenName: screenName, isClosed: isClosed, type: type, isAdmin: isAdmin, isMember: isMember, isAdvertiser: isAdvertiser, activity: activity, membersCount: membersCount , photo100: photo100, adminLevel: adminLevel)
    }
    
}
