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
        return ["firstName", "lastName"] //В перспективе добавить online, deactivated
    }
    
    var groups = List<GroupRealm>()
    
    func toModel() -> UserVK {
        return UserVK(id: id, firstName: firstName, lastName: lastName, isClosed: isClosed, canAccessClosed: canAccessClosed, photo100: photo100, online: online, deactivated: deactivated)
    }
}


class UserRepositoryRealm {
    
   var userRealm: UserRealm!
    
    func addUser(id: Int, firstName: String, lastName: String, isClosed: Bool, canAccessClosed: Bool, photo100: String, online: Int, deactivated: String) {
        let realm = try? Realm()
        let newUser = UserRealm()
        newUser.id = id
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.isClosed = isClosed
        newUser.canAccessClosed = canAccessClosed
        newUser.photo100 = photo100
        newUser.online = online
        newUser.deactivated = deactivated
        
        try? realm?.write {
            realm?.add(newUser)
            self.userRealm = newUser
        }
    }
    
    func getUser(id: Int) -> UserRealm? {
        let realm = try! Realm()
        return realm.objects(UserRealm.self).filter("id == %@", id).first
    }
    
    func updateUser(id: Int, firstName: String, lastName: String, isClosed: Bool, canAccessClosed: Bool, photo100: String, online: Int, deactivated: String) {
        let realm = try! Realm()
        try! realm.write {
            self.userRealm.id = id
            self.userRealm.firstName = firstName
            self.userRealm.lastName = lastName
            self.userRealm.isClosed = isClosed
            self.userRealm.canAccessClosed = canAccessClosed
            self.userRealm.photo100 = photo100
            self.userRealm.online = online
            self.userRealm.deactivated = deactivated
        }
    }
    
    func getAllUsers() -> Results<UserRealm> {
        let realm = try! Realm()
        return realm.objects(UserRealm.self)
    }
    
}
