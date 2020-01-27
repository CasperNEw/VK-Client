import Foundation

//struct ResponseGroup: Codable {
//    let response: ResponseDataGroup
//}
//
//struct ResponseDataGroup: Codable {
//    let count: Int
//    let items: [GroupVK]
//}

struct GroupVK: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: TypeEnum
    let isAdmin, isMember, isAdvertiser: Int
    let photo50: String
    let adminLevel: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case adminLevel = "admin_level"
    }
}

enum TypeEnum: String, Codable {
    case event = "event"
    case group = "group"
    case page = "page"
}
