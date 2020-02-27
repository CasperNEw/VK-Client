//
//  ProfileVK.swift
//  VK
//
//  Created by Дмитрий Константинов on 25.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct ProfileVK {
    
    var id: Int
    var firstName: String
    var lastName: String
    var fullname: String { return firstName + " " + lastName }
    var online: Int
    var lastSeenTime: Int
    var lastSeenPlatform: Int
    var status: String
    var friendsCount: Int
    var mutualFriendsCount: Int
    var followersCount: Int
    var city: String
    var career: String
    
    var photoPath: String
    var photoWidth: Double
    var photoHeight: Double
    var photoRectX1: Double
    var photoRectY1: Double
    var photoRectX2: Double
    var photoRectY2: Double
    
    var photos: [String]
}
