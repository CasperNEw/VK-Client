//
//  NewsVK.swift
//  VK
//
//  Created by Дмитрий Константинов on 22.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct CommonResponseNews: Codable {
    let response: ResponseNews
}

struct ResponseNews: Codable {
    let items: [NewsVK]
    let profiles: [UserVK]
    let groups: [GroupVK]
    let nextFrom: String?

    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

struct NewsVK: Codable {
    let id: Int?
    let ownerId: Int?
    let sourceId: Int?
    let fromId: Int?
    let date: Int
    let text: String
    let attachments: [Attachment]?
    let comments: CommentsNews
    let likes: LikesNews
    let reposts: RepostsNews
    let views: ViewsNews?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case sourceId = "source_id"
        case fromId = "from_id"
        case date
        case text
        case attachments
        case comments, likes, reposts, views
    }
}

struct Attachment: Codable {
    let type: String
    let photo: PhotoNews?
}

struct PhotoNews: Codable {
    let sizes: [Size]
}

struct CommentsNews: Codable {
    let count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }
}

struct LikesNews: Codable {
    let count, userLikes: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
}

struct RepostsNews: Codable {
    let count, userReposted: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

struct ViewsNews: Codable {
    let count: Int
}
