import Foundation

struct Response: Codable {
    let response: ResponseData
}

struct ResponseData: Codable {
    let count: Int
    let items: [UserVK]
}

struct UserVK: Codable {
    let id: Int
    let firstName, lastName: String
    var fullname: String { return firstName + " " + lastName }
    let isClosed, canAccessClosed: Bool?
    let photo50: String
    let online: Int
    let trackCode: String
    let deactivated: Deactivated?
    let lists: [Int]?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case photo50 = "photo_50"
        case online
        case trackCode = "track_code"
        case deactivated, lists
    }
}

enum Deactivated: String, Codable {
    case banned = "banned"
    case deleted = "deleted"
}
