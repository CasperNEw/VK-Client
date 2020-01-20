import Foundation

struct ResponseUserSpecial: Codable {
    let response: [UserSpecial]
}

struct UserSpecial: Codable {
    let id: Int
    let firstName, lastName: String
    let isClosed, canAccessClosed: Bool
    let city: City
    let photo200: String?
    let status: String?
    let counters: Counters
    let career: [Career]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case city
        case photo200 = "photo_200"
        case status, counters, career
    }
}

struct City: Codable {
    let id: Int?
    let title: String?
}

struct Counters: Codable {
    let albums: Int?
    let videos: Int?
    let audios: Int?
    let photos: Int?
    let notes: Int?
    let friends: Int?
    let groups: Int?
    let onlineFriends: Int?
    let mutualFriends: Int?
    let userVideos: Int?
    let followers: Int?
    let pages: Int?
    
    enum CodingKeys: String, CodingKey {
        case albums
        case videos
        case audios
        case photos
        case notes
        case friends
        case groups
        case onlineFriends = "online_friends"
        case mutualFriends = "mutual_Friends"
        case userVideos = "user_videos"
        case followers
        case pages
    }
}
    
struct Career: Codable {
    let groupId: Int?
    let company: String?
    let countryId: Int?
    let cityId: Int?
    let cityName: String?
    let from: Int?
    let until: Int?
    let position: String?
    
    enum CodingKeys: String, CodingKey {
        case groupId = "group_id"
        case company
        case countryId = "country_id"
        case cityId = "city_id"
        case cityName = "city_name"
        case from
        case until
        case position
    }
}
