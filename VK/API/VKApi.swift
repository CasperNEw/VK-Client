import UIKit
import Alamofire
import KeychainAccess

enum RequestError: Error {
    case failedRequest(message: String)
    case decodableError
}

class VKApi {
    
    let vkURL = "https://api.vk.com/method/"
    
    func requestServer<T: Decodable>(requestURL: String,
                                     method: HTTPMethod = .post,
                                     params: Parameters,
                                     completion: @escaping (Swift.Result<[T], Error>) -> Void) {
        Alamofire.request(requestURL, method: method, parameters: params)
            .responseData { result in
                
                guard let data = result.value else {
                    completion(.failure(RequestError.failedRequest(message: "[Error] Request failed ")))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(CommonResponse<T>.self, from: data)
                    completion(.success(result.response.items))
                } catch {
                    //TODO: Error processing
                    completion(.failure(error))
                }
        }
    }
    
    func getFriendList(token: String, version: String, completion: @escaping (Swift.Result<[UserVK], Error>) -> Void) {
        let requestURL = vkURL + "friends.get"
        let params = ["access_token": token,
                      "order": "hints",
                      "fields": "photo_100",
                      "v": version]
        
        requestServer(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
    
    func getUser(token: String, userId: String, version: String, completion: @escaping (Swift.Result<[AdvancedUserVK], Error>) -> Void ) {
        let requestURL = vkURL + "users.get"
        let params = ["access_token": token,
                      "user_id": userId,
                      "fields": "status,city,career,counters,has_photo,crop_photo,last_seen,online",
                      "v": version]
       
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params)
            .responseData { (result) in
                guard let data = result.value else { return }
                do {
                    print(data)
                    print(params)
                    let result = try JSONDecoder().decode(ResponseAdvancedUser.self, from: data)
                    completion(.success(result.response))
                } catch {
                    completion(.failure(error))
                }
        }
    }
    
    func getUserPhoto(token: String, version: String, ownerId: String, completion: @escaping (Swift.Result<[PhotoVK], Error>) -> Void ) {
        let requestURL = vkURL + "photos.getAll"
        let params = ["access_token": token,
                      "owner_id": ownerId,
                      "no_service_albums": "0",
                      "extended": "1",
                      "photo_sizes": "1",
                      "v": version] as [String : Any]
        
        requestServer(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
    
    func getGroupList(token: String, version: String, user: String, completion: @escaping (Swift.Result<[GroupVK], Error>) -> Void ) {
        let requestURL = vkURL + "groups.get"
        let params = ["access_token": token,
                      "user_id": user,
                      "extended": "1",
                      "fields": "activity,photo_100,members_count",
                      "v": version]
        
        requestServer(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
    
    //пока не используем данный метод, попозже перепишем ;)
    func getFilteredGroupList(token: String, version: String, user: String, text: String) {
        let requestURL = vkURL + "groups.search"
        let params = ["access_token": token,
                      "user_id": user,
                      "q": text,
                      "is_member": "1",
                      "type": "group",
                      "v": version]
        
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params).responseJSON(completionHandler: { (response) in
                            print(response.value as? [String: Any] ?? "[Logging] JSON error")
                          })
    }
    
    func getNewsList(token: String, userId:String, from: String?, version: String, completion: @escaping (Swift.Result<ResponseNews, Error>) -> Void ) {
        let requestURL = vkURL + "newsfeed.get"
        var params: [String : String]
        if let myFrom = from {
            params = ["access_token": token,
                          "user_id": userId,
                          "source_ids": "friends,groups,pages",
                          "filters": "post",
                          "count": "20",
                          "fields": "first_name,last_name,name,photo_100,online",
                          "start_from": myFrom,
                          "v": version]
            
        } else {
            params = ["access_token": token,
                          "user_id": userId,
                          "source_ids": "friends,groups,pages",
                          "filters": "post",
                          "count": "20",
                          "fields": "first_name,last_name,name,photo_100,online",
                          "v": version]
        }
        //Делаем остановку на дозагрузку, как в нативном VK-клиенте. Защита при одновременном срабатывании методов дозагрузки и обновления.
        Alamofire.SessionManager.default.session.getAllTasks { tasks in tasks.forEach{ $0.cancel()} }
        
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params as Parameters)
            .responseData { (result) in
                guard let data = result.value else { return }
                do {
                    let result = try JSONDecoder().decode(CommonResponseNews.self, from: data)
                    completion(.success(result.response))
                } catch {
                    
                    //Пример обработки определенной ошибки (5: токен привязан к другому IP адресу)
                    do {
                        let result = try JSONDecoder().decode(ResponseErrorVK.self, from: data)
                        if result.error.errorCode == 5 {
                            let keychain = Keychain(service: "UserSecrets")
                            keychain["token"] = nil
                            keychain["userId"] = nil
                            print("[Logging] Your data is cleared, please restart the application")
                        }
                        completion(.failure(error))
                    } catch {
                        completion(.failure(error))
                    }
                    completion(.failure(error))
                }
        }
    }
    
    func getWall(token: String, ownerId: String, version: String, completion: @escaping (Swift.Result<ResponseNews, Error>) -> Void ) {
        let requestURL = vkURL + "wall.get"
        var params: [String : String]
        params = ["access_token": token,
                  "owner_id": ownerId,
                  "extended": "1",
                  "filters": "post",
                  "fields": "first_name,last_name,name,photo_100,online",
                  "v": version]
        
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params as Parameters)
            .responseData { (result) in
                guard let data = result.value else { return }
                do {
                    print(result)
                    let result = try JSONDecoder().decode(CommonResponseNews.self, from: data)
                    completion(.success(result.response))
                } catch {
                    completion(.failure(error))
                }
        }
    }
    
}
