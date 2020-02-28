//
//  GlobalGroupRepository.swift
//  VK
//
//  Created by Дмитрий Константинов on 27.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation
import RealmSwift

protocol GlobalGroupSourse {
    func getUserGroups() throws -> Results<GroupRealm>
    func addGroups(groups: [GroupVK])
    func searchGroups(name: String) throws -> Results<GroupRealm>
    func deleteGroups() throws
}

class GlobalGroupRepository: GlobalGroupSourse {
    
    func getUserGroups() throws -> Results<GroupRealm> {
        do {
            let realm = try Realm()
            return realm.objects(GroupRealm.self).filter("isMember == 1")
        } catch {
            throw error
        }
    }
    
    func addGroups(groups: [GroupVK]) {
        do {
            let realm = try Realm()
            
            try realm.write() {
                var groupsToAdd = [GroupRealm]()
                groups.forEach { group in
                    let groupRealm = GroupRealm()
                    
                    groupRealm.id = group.id
                    groupRealm.name = group.name
                    groupRealm.screenName = group.screenName
                    groupRealm.isClosed = group.isClosed
                    groupRealm.type = group.type
                    groupRealm.isAdmin = group.isAdmin ?? -1
                    groupRealm.isMember = group.isMember ?? -1
                    groupRealm.isAdvertiser = group.isAdvertiser ?? -1
                    groupRealm.activity = group.activity ?? ""
                    groupRealm.membersCount = group.membersCount ?? 0
                    groupRealm.photo100 = group.photo100
                    groupRealm.adminLevel = 15
                    
                    groupsToAdd.append(groupRealm)
                }
                realm.add(groupsToAdd, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func searchGroups(name: String) throws -> Results<GroupRealm> {
        do {
            let realm = try Realm()
            return realm.objects(GroupRealm.self).filter("name CONTAINS[c] %@", name)
        } catch {
            throw error
        }
    }
    
    func deleteGroups() throws {
        print("[Logging] SAVE NEWS")
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.delete(realm.objects(GroupRealm.self).filter("adminLevel = 15"))
            }
        } catch {
            throw error
        }
    }
}
