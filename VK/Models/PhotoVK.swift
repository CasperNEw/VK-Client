//
//  PhotoVK.swift
//  VK
//
//  Created by Дмитрий Константинов on 02.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct PhotoVK: Codable {
    let id, albumID, ownerID: Int
    let sizes: [PhotoSize]
    let text: String
    let date: Int
    let likes: PhotoLikes
    let reposts: PhotoReposts

    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case sizes, text, date
        case likes, reposts
    }
}

struct PhotoReposts: Codable {
    let count: Int
}

struct PhotoLikes: Codable {
    let userLikes, count: Int

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

struct PhotoSize: Codable {
    let type: String
    let url: String
    let width, height: Int
    
    func toRealm() -> PhotoSizesRealm {
        let photoRealm = PhotoSizesRealm()
        photoRealm.type = type
        photoRealm.url = url
        photoRealm.width = width
        photoRealm.height = height
        return photoRealm
    }
}
