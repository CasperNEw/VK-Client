import Foundation

struct UserVK: Codable {
    let id: Int
    let firstName, lastName: String
    var fullname: String { return firstName + " " + lastName }
    let isClosed, canAccessClosed: Bool?
    let photo100: String
    let online: Int
    let deactivated: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case photo100 = "photo_100"
        case online
        case deactivated
    }
}
