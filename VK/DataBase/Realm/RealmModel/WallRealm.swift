//
//  WallRealm.swift
//  VK
//
//  Created by Дмитрий Константинов on 27.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation
import RealmSwift

class WallRealm: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var ownerId = 0
    @objc dynamic var fromId = 0
    @objc dynamic var text = ""
    @objc dynamic var likes = 0
    @objc dynamic var userLikes = 0
    @objc dynamic var views = 0
    @objc dynamic var comments = 0
    @objc dynamic var reposts = 0
    @objc dynamic var date = 0
    @objc dynamic var authorImagePath = ""
    @objc dynamic var authorName = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    override class func indexedProperties() -> [String] {
        return ["ownerId"]
    }
    
    var photos = List<String>()
    
    func toModel() -> PostVK {
        
        var photosToModel = [String]()
        photos.forEach { photosToModel.append($0) }
    
        return PostVK(id: id, ownerId: ownerId, text: text, likes: likes, userLikes: userLikes, views: views, comments: comments, reposts: reposts, date: date, authorImagePath: authorImagePath, authorName: authorName, photos: photosToModel)
    }
}
