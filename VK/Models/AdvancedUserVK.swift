import Foundation

struct ResponseAdvancedUser: Codable {
    let response: [AdvancedUserVK]
}

struct AdvancedUserVK: Codable {
    let id: Int
    let firstName, lastName: String
    var fullname: String { return firstName + " " + lastName }
    let city: City?
    let hasPhoto, online: Int
    let status: String?
    let lastSeen: LastSeen
    let cropPhoto: CropPhoto?
    let counters: Counters
    let career: [Career]?
    
    enum CodingKeys: String, CodingKey {
           case id
           case firstName = "first_name"
           case lastName = "last_name"
           case city
           case hasPhoto = "has_photo"
           case online, status
           case lastSeen = "last_seen"
           case cropPhoto = "crop_photo"
           case counters, career
       }
}

struct City: Codable {
    let title: String?
}

struct LastSeen: Codable {
    let time, platform: Int
}

struct CropPhoto: Codable {
    let photo: Photo
    let crop, rect: Crop
}

struct Photo: Codable {
    let sizes: [Size]
}

struct Crop: Codable {
    let x, y, x2, y2: Double
}

struct Counters: Codable {
    let photos: Int?
    let friends: Int?
    let mutualFriends: Int?
    let followers: Int?
    
    enum CodingKeys: String, CodingKey {
        case photos
        case friends
        case mutualFriends = "mutual_friends"
        case followers
    }
}
    
struct Career: Codable {
    let company: String?
}

struct Size: Codable {
    let type: String
    let url: String
    let width, height: Int
}
