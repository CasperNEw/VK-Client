import UIKit
import Alamofire

enum Album { case wall, profile, saved }
/*
struct ResponseData: Codable {
    var count: Int
    var items: [User]
}

struct Response: Codable {
    var response: ResponseData
}
*/
class VKApi {
    
    let vkURL = "https://api.vk.com/method/"
    
    func getFriendList(token: String, completion: @escaping ([UserVK]) -> Void ) {
        let requestURL = vkURL + "friends.get"
        let params = ["access_token": token,
                      "order": "hints",
                      "fields": "photo_50, status",
                      "v": "5.103"]
        
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params).responseData { (response) in
                            guard let data = response.value else { return }
                            do {
                                let userVK = try JSONDecoder().decode(Response.self, from: data).response.items
                                completion(userVK)
                            } catch {
                                //Notify user
                                print(error)
                            }
        }
    }
    
    func getUserSpecialInformation(token: String, userId:String, completion: @escaping ([UserSpecial]) -> Void ) {
        let requestURL = vkURL + "users.get"
        let params = ["access_token": token,
                      "user_id": userId,
                      "fields": "photo_200, status, city, career, counters",
                      "v": "5.103"]
        
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params).responseData { (response) in
                            guard let data = response.value else { return }
                            do {
                                let userSpecial = try JSONDecoder().decode(ResponseUserSpecial.self, from: data).response.self
                                completion(userSpecial)
                            } catch {
                                //Notify user
                                print(error)
                            }
        }
    }
    
    func getPhotoInAlbum(token: String, ownerId: String, album: Album, completion: @escaping ([PhotoVK]) -> Void ) {
        let requestURL = vkURL + "photos.get"
        let params = ["access_token": token,
                      "owner_id": ownerId,
                      "album_id": album,
                      "rev": "1",
                      "extended": "1",
                      "photo_sizes": "1",
                      "v": "5.103"] as [String : Any]
        
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params).responseData { (response) in
                            guard let data = response.value else { return }
                            do {
                                let photoVK = try JSONDecoder().decode(ResponsePhoto.self, from: data).response.items
                                completion(photoVK)
                            } catch {
                                //Notify user
                                print(error)
                          }
        }
    }
    
    func getGroupListForUser(token: String, user: String, completion: @escaping ([GroupVK]) -> Void ) {
        let requestURL = vkURL + "groups.get"
        let params = ["access_token": token,
                      "user_id": user,
                      "extended": "1",
                      "fields": "photo_50",
                      "v": "5.103"]
        
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params).responseData { (response) in
                            guard let data = response.value else { return }
                            do {
                                let groupVK = try JSONDecoder().decode(ResponseGroup.self, from: data).response.items
                                completion(groupVK)
                            } catch {
                                //Notify user
                                print(error)
                            }
        }
    }
    
    func getFilteredGroupList(token: String, user: String, text: String) {
        let requestURL = vkURL + "groups.search"
        let params = ["access_token": token,
                      "user_id": user,
                      "q": text,
                      "is_member": "1", // ?
                      "type": "group",
                      "v": "5.103"]
        
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params).responseJSON(completionHandler: { (response) in
                            print(response.value as? [String: Any] ?? "[Logging] JSON error")
                          })
    }
    
}
