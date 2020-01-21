import Foundation
import RealmSwift

class UserRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var isClosed = false
    @objc dynamic var canAccessClosed = false
    @objc dynamic var photo50 = ""
    @objc dynamic var online = 0
    @objc dynamic var trackCode = ""
    @objc dynamic var deactivated = 0
    @objc dynamic var lists = 0
    
    var groups = List<GroupRealm>()
}


class UserRepositoryRealm {
    
   var userRealm: UserRealm!
    
    func addUser(id: Int, firstName: String, lastName: String, isClosed: Bool, canAccessClosed: Bool, photo50: String, online: Int, trackCode: String, deactivated: Int, lists: Int) {
        let realm = try? Realm()
        let newUser = UserRealm()
        newUser.id = id
        newUser.firstName = firstName
        newUser.lastName = lastName
        newUser.isClosed = isClosed
        newUser.canAccessClosed = canAccessClosed
        newUser.photo50 = photo50
        newUser.online = online
        newUser.trackCode = trackCode
        newUser.deactivated = deactivated
        newUser.lists = lists
        
        try? realm?.write {
            realm?.add(newUser)
            self.userRealm = newUser
        }
    }
    
    func getUser(id: Int) -> UserRealm? {
        let realm = try! Realm()
        return realm.objects(UserRealm.self).filter("id == %@", id).first
    }
    
    func updateUser(id: Int, firstName: String, lastName: String, isClosed: Bool, canAccessClosed: Bool, photo50: String, online: Int, trackCode: String, deactivated: Int, lists: Int) {
        let realm = try! Realm()
        try! realm.write {
            self.userRealm.id = id
            self.userRealm.firstName = firstName
            self.userRealm.lastName = lastName
            self.userRealm.isClosed = isClosed
            self.userRealm.canAccessClosed = canAccessClosed
            self.userRealm.photo50 = photo50
            self.userRealm.online = online
            self.userRealm.trackCode = trackCode
            self.userRealm.deactivated = deactivated
            self.userRealm.lists = lists
        }
    }
    
    func getAllUsers() -> Results<UserRealm> {
        let realm = try! Realm()
        return realm.objects(UserRealm.self)
    }
    
}
