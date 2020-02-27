import Foundation

struct GroupVK: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: String
    let isAdmin, isMember, isAdvertiser: Int?
    let activity: String?
    let membersCount: Int?
    let photo100: String
    let adminLevel: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case activity
        case membersCount = "members_count"
        case photo100 = "photo_100"
        case adminLevel = "admin_level"
    }
}
