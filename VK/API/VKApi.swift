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
                      "fields": "photo_50",
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
    
    func getPhotoInAlbum(token: String, user: String, album: Album) {
        let requestURL = vkURL + "photos.get"
        let params = ["owner_id": user,
                      "access_token": token,
                      "album_id": album,
                      "rev": "1",
                      "v": "5.103"] as [String : Any]
        
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params).responseJSON(completionHandler: { (response) in
                            print(response.value as? [String: Any] ?? "[Logging] JSON error")
                          })
    }
    
    func getGroupListForUser(token: String, user: String) {
        let requestURL = vkURL + "groups.get"
        let params = ["access_token": token,
                      "user_id": user,
                      "v": "5.103"]
        
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params).responseJSON(completionHandler: { (response) in
                            print(response.value as? [String: Any] ?? "[Logging] JSON error")
                          })
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
