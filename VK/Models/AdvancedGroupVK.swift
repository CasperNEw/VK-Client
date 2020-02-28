//
//  AdvancedGroupVK.swift
//  VK
//
//  Created by Дмитрий Константинов on 28.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct ResponseAdvancedGroup: Codable {
    let response: [AdvancedGroupVK]
}

struct AdvancedGroupVK: Codable {
    let id: Int
    let name: String
    let screenName: String
    let membersCount: Int
    let city: City?
    let site: String
    let cropPhoto: CropPhoto?
    let photo100: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case screenName = "screen_name"
        case membersCount = "members_count"
        case city
        case site
        case cropPhoto = "crop_photo"
        case photo100 = "photo_100"
    }
}
