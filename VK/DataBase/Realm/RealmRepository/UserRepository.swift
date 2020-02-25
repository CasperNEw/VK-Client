//
//  UserRepository.swift
//  VK
//
//  Created by Дмитрий Константинов on 31.01.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import RealmSwift

protocol UserSourse {
    func getAllUsers() throws -> Results<UserRealm>
    func addUsers(users: [UserVK])
    func searchUsers(name: String) throws -> Results<UserRealm>
}

class UserRepository: UserSourse {
    
    func getAllUsers() throws -> Results<UserRealm> {
        do {
            let realm = try Realm()
            return realm.objects(UserRealm.self)
        } catch {
            throw error
        }
    }
    
    func searchUsers(name: String) throws -> Results<UserRealm> {
        do {
            let realm = try Realm()
            return realm.objects(UserRealm.self).filter("firstName CONTAINS[c] %@ OR lastName CONTAINS[c] %@", name, name)
        } catch {
            throw error
        }
    }
    
    func addUsers(users: [UserVK]) {
        do {
            let realm = try Realm()
            try realm.write {
                var usersToAdd = [UserRealm]()
                users.forEach { user in
                    let userRealm = UserRealm()
                    userRealm.id = user.id
                    userRealm.firstName = user.firstName
                    userRealm.lastName = user.lastName
                    userRealm.isClosed = user.isClosed ?? false
                    userRealm.canAccessClosed = user.canAccessClosed ?? true
                    userRealm.photo100 = user.photo100
                    userRealm.online = user.online
                    userRealm.deactivated = user.deactivated ?? ""
                    usersToAdd.append(userRealm)
                }
                print("[Logging] UserRealm get entities - \(usersToAdd.count)")
                realm.add(usersToAdd, update: .modified)
            }
            //print(realm.objects(UserRealm.self))
        } catch {
            print(error)
        }
    }
}
