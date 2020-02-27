//
//  UserSpecialRepository.swift
//  VK
//
//  Created by Дмитрий Константинов on 25.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import RealmSwift

protocol ProfileSource {
    func getProfile(id: Int) throws -> Results<ProfileRealm>
    func addProfile(profile: ProfileVK)
}

class ProfileRepository: ProfileSource {
    
    func getProfile(id: Int) throws -> Results<ProfileRealm> {
        do {
            let realm = try Realm()
            return realm.objects(ProfileRealm.self).filter("id == %@", id)
        } catch {
            throw error
        }
    }
    
    func addProfile(profile: ProfileVK) {
        do {
            let realm = try Realm()
            try realm.write {
                let profileToAdd = ProfileRealm()
                
                profileToAdd.id = profile.id
                profileToAdd.firstName = profile.firstName
                profileToAdd.lastName = profile.lastName
                profileToAdd.online = profile.online
                profileToAdd.lastSeenTime = profile.lastSeenTime
                profileToAdd.lastSeenPlatform = profile.lastSeenPlatform
                profileToAdd.status = profile.status
                profileToAdd.friendsCount = profile.friendsCount
                profileToAdd.mutualFriendsCount = profile.mutualFriendsCount
                profileToAdd.followersCount = profile.followersCount
                profileToAdd.city = profile.city
                profileToAdd.career = profile.career
                profileToAdd.photoPath = profile.photoPath
                profileToAdd.photoWidth = profile.photoWidth
                profileToAdd.photoHeight = profile.photoHeight
                profileToAdd.photoRectX1 = profile.photoRectX1
                profileToAdd.photoRectY1 = profile.photoRectY1
                profileToAdd.photoRectX2 = profile.photoRectX2
                profileToAdd.photoRectY2 = profile.photoRectY2
                profile.photos.forEach { profileToAdd.photos.append($0) }
                
                realm.add(profileToAdd, update: .modified)
                print("[Logging] ProfileRealm get entities - \(profile.fullname)")
            }
        } catch {
            print(error)
        }
    }
}
