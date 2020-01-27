import Foundation

enum Album { case wall, profile, saved }

//struct ResponsePhoto: Codable {
//    let response: ResponseDataPhoto
//}
//
//struct ResponseDataPhoto: Codable {
//    let count: Int
//    let items: [PhotoVK]
//}

struct PhotoVK: Codable {
    let id, albumID, ownerID: Int
    let sizes: [Size]
    let text: String
    let date, postID: Int?
    let likes: Likes
    let reposts, comments: Comments
    let canComment: Int
    let tags: Comments

    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case sizes, text, date
        case postID = "post_id"
        case likes, reposts, comments
        case canComment = "can_comment"
        case tags
    }
}

struct Comments: Codable {
    let count: Int
}

struct Likes: Codable {
    let userLikes, count: Int

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

struct Size: Codable {
    let type: String
    let url: String
    let width, height: Int
}
