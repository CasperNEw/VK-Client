//
//  PostVK.swift
//  VK
//
//  Created by Дмитрий Константинов on 23.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct PostVK {
    
    var id: Int?
    var ownerId: Int?
    var fromId: Int?
    var text: String
    var likes: Int
    var userLikes: Int
    var views: Int
    var comments: Int
    var reposts: Int
    var date: Int
    var authorImagePath: String
    var authorName: String
    var photos: [String]
    
}
