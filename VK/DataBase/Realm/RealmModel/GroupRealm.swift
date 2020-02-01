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
    @objc dynamic var photo50 = ""
    @objc dynamic var adminLevel = 0
}

class GroupRepositoryRealm {
    
   var groupRealm: GroupRealm!
    
    func addGroup(id: Int, name: String, screenName: String, isClosed: Int, type: String, isAdmin: Int, isMember: Int, isAdvertiser: Int, photo50: String, adminLevel: Int) {
        
        let realm = try? Realm()
        let newGroup = GroupRealm()
        
        newGroup.id = id
        newGroup.name = name
        newGroup.screenName = screenName
        newGroup.isClosed = isClosed
        newGroup.type = type
        newGroup.isAdmin = isAdmin
        newGroup.isMember = isMember
        newGroup.isAdvertiser = isAdvertiser
        newGroup.photo50 = photo50
        newGroup.adminLevel = adminLevel
        
        try? realm?.write {
            realm?.add(newGroup)
            self.groupRealm = newGroup
        }
    }
    
    func getGroup(id: Int) -> GroupRealm? {
        let realm = try! Realm()
        return realm.objects(GroupRealm.self).filter("id == %@", id).first
    }
    
    func updateGroup(id: Int, name: String, screenName: String, isClosed: Int, type: String, isAdmin: Int, isMember: Int, isAdvertiser: Int, photo50: String, adminLevel: Int) {
        
        let realm = try! Realm()
        try! realm.write {
            
            self.groupRealm.id = id
            self.groupRealm.name = name
            self.groupRealm.screenName = screenName
            self.groupRealm.isClosed = isClosed
            self.groupRealm.type = type
            self.groupRealm.isAdmin = isAdmin
            self.groupRealm.isMember = isMember
            self.groupRealm.isAdvertiser = isAdvertiser
            self.groupRealm.photo50 = photo50
            self.groupRealm.adminLevel = adminLevel
        }
    }
    
    func getAllGroups() -> Results<GroupRealm> {
        let realm = try! Realm()
        return realm.objects(GroupRealm.self)
    }
}
