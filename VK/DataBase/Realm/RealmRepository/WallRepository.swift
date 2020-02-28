//
//  WallRepository.swift
//  VK
//
//  Created by Дмитрий Константинов on 27.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import RealmSwift

protocol WallSource {
    func getWall(ownerId: Int) throws -> Results<WallRealm>
    func addWall(posts: [PostVK])
    func searchOnWall(text: String) throws -> Results<WallRealm>
    func deleteWall() throws
}

class WallRepository: WallSource {
    
    func getWall(ownerId: Int) throws -> Results<WallRealm> {
        do {
            let realm = try Realm()
            return realm.objects(WallRealm.self).filter("ownerId == %@", ownerId)
        } catch {
            throw error
        }
    }
    
    func addWall(posts: [PostVK]) {
        do {
            let realm = try Realm()
            try realm.write {
                var wallToAdd = [WallRealm]()
                posts.forEach { post in
                    if let id = post.id {
                        if let ownerId = post.ownerId {
                            let postRealm = WallRealm()
                            postRealm.id = id
                            postRealm.ownerId = ownerId
                            postRealm.text = post.text
                            postRealm.likes = post.likes
                            postRealm.userLikes = post.userLikes
                            postRealm.views = post.views
                            postRealm.comments = post.comments
                            postRealm.reposts = post.reposts
                            postRealm.date = post.date
                            postRealm.authorImagePath = post.authorImagePath
                            postRealm.authorName = post.authorName
                            post.photos.forEach { postRealm.photos.append($0)  }
                            wallToAdd.append(postRealm)
                        }
                    }
                }
                realm.add(wallToAdd, update: .modified)
                print("[Logging] NewsRealm get entities - \(wallToAdd.count)")
            }
        } catch {
            print(error)
        }
    }
    
    func searchOnWall(text: String) throws -> Results<WallRealm> {
        do {
            let realm = try Realm()
            return realm.objects(WallRealm.self).filter("text CONTAINS[c] %@", text)
        } catch {
            throw error
        }
    }
    
    func deleteWall() throws {
        do {
            let realm = try Realm()
            try realm.write {
                realm.delete(realm.objects(WallRealm.self))
            }
        } catch {
            throw error
        }
    }
    
}
