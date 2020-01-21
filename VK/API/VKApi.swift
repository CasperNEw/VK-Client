import UIKit
import Alamofire

enum RequestError: Error {
    case failedRequest(message: String)
    case decodableError
}

enum Album { case wall, profile, saved }

class VKApi {
    
    let vkURL = "https://api.vk.com/method/"
    
    func requestServer<T: Decodable>(requestURL: String,
                                     params: Parameters,
                                     completion: @escaping (Swift.Result<T, Error>) -> Void) {
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params)
            .responseData { (response) in
                switch response.result {
                case .failure(let error):
                    completion(.failure(RequestError.failedRequest(message: error.localizedDescription)))
                case .success:
                    do {
                        guard let data = response.value else { return }
                        let response = try JSONDecoder().decode(T.self, from: data)
        completion(.success(response))
                    } catch _ {
        completion(.failure(RequestError.decodableError))
                    }
                }
        }
    }
    
    func getFriendList(token: String, completion: @escaping (Swift.Result<[UserVK], Error>) -> Void) {
        let requestURL = vkURL + "friends.get"
        let params = ["access_token": token,
                      "order": "hints",
                      "fields": "photo_50, status",
                      "v": "5.103"]
        
        requestServer(requestURL: requestURL, params: params) { (users: Swift.Result<Response, Error>) in
            switch users {
            case .failure(let error):
                completion(.failure(error))
            case .success(let user):
                let userVK = user.response.items
                completion(.success(userVK))
            }
        }
    }
    func getUserSpecialInformation(token: String, userId:String, completion: @escaping (Swift.Result<[UserSpecial], Error>) -> Void ) {
        let requestURL = vkURL + "users.get"
        let params = ["access_token": token,
                      "user_id": userId,
                      "fields": "photo_200, status, city, career, counters",
                      "v": "5.103"]
        
        requestServer(requestURL: requestURL, params: params) { (users: Swift.Result<ResponseUserSpecial, Error>) in
            switch users {
            case .failure(let error):
                completion(.failure(error))
            case .success(let user):
                let userSpecial = user.response
                completion(.success(userSpecial))
            }
        }
    }
    func getPhotoInAlbum(token: String, ownerId: String, album: Album, completion: @escaping (Swift.Result<[PhotoVK], Error>) -> Void ) {
        let requestURL = vkURL + "photos.get"
        let params = ["access_token": token,
                      "owner_id": ownerId,
                      "album_id": album,
                      "rev": "1",
                      "extended": "1",
                      "photo_sizes": "1",
                      "v": "5.103"] as [String : Any]
        
        requestServer(requestURL: requestURL, params: params) { (photoVK: Swift.Result<ResponsePhoto, Error>) in
            switch photoVK {
            case .failure(let error):
                completion(.failure(error))
            case .success(let album):
                let photo = album.response.items
                completion(.success(photo))
            }
        }
    }
    
    func getGroupListForUser(token: String, user: String, completion: @escaping (Swift.Result<[GroupVK], Error>) -> Void ) {
        let requestURL = vkURL + "groups.get"
        let params = ["access_token": token,
                      "user_id": user,
                      "extended": "1",
                      "fields": "photo_50",
                      "v": "5.103"]
        
        requestServer(requestURL: requestURL, params: params) { (group: Swift.Result<ResponseGroup, Error>) in
            switch group {
            case .failure(let error):
                completion(.failure(error))
            case .success(let groups):
                let groupVK = groups.response.items
                completion(.success(groupVK))
            }
        }
    }
    //пока не используем данный метод, попозже перепишем ;)
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
