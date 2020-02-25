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
                
                /*
                //TODO
                //Надо добавить логику проверки валидности токена
                 
                //Удаляем данные из Keychain
                let keychain = Keychain(service: "UserSecrets")
                keychain["token"] = nil
                keychain["userId"] = nil
                */
                
                guard let data = result.value else {
                    completion(.failure(RequestError.failedRequest(message: "[Error] Request failed ")))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(CommonResponse<T>.self, from: data)
                    completion(.success(result.response.items))
                } catch {
                    completion(.failure(error))
                    
                    /*
                    //Хотел сделать переход в момент ошибки, но во первых не осилил как правильно распарсить ошибку что бы понимать что дело именно в токене, а во вторых не осилил как сделать переход.
                     
                    //Выдает ошибку на навигейшн контроллер, как понял из гугла, ошибка связана с тем что он не может начать делать анимацию во время выполнения другой анимации, задержка выполнения погоды не сделала.
                     
                    //Unbalanced calls to begin/end appearance transitions for <UINavigationController: 0x7f89138c1600>.
                     
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        var window: UIWindow
                        window = UIWindow(frame: UIScreen.main.bounds)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let mainVC = storyboard.instantiateViewController(withIdentifier: "LoginWebView")
                        window.rootViewController = UINavigationController(rootViewController: mainVC)
                        window.makeKeyAndVisible()
                    }
                    */
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
    
    func getUserSpecialInformation(token: String, userId:String, completion: @escaping (Swift.Result<[AdvancedUserVK], Error>) -> Void ) {
        let requestURL = vkURL + "users.get"
        let params = ["access_token": token,
                      "user_id": userId,
                      "fields": "photo_200, status, city, career, counters",
                      "v": "5.103"]
        
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: params)
            .responseData { (result) in
                guard let data = result.value else { return }
                do {
                    let result = try JSONDecoder().decode(ResponseAdvancedUser.self, from: data)
                    completion(.success(result.response))
                } catch {
                    completion(.failure(error))
                }
        }
    }
    func getPhotoInAlbum(token: String, version: String, ownerId: String, album: Album, completion: @escaping (Swift.Result<[PhotoSpVK], Error>) -> Void ) {
        let requestURL = vkURL + "photos.get"
        let params = ["access_token": token,
                      "owner_id": ownerId,
                      "album_id": album,
                      "rev": "1",
                      "extended": "1",
                      "photo_sizes": "1",
                      "v": version] as [String : Any]
        
        requestServer(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
    
    func getUsersPhoto(token: String, version: String, ownerId: String, completion: @escaping (Swift.Result<[PhotoSpVK], Error>) -> Void ) {
        let requestURL = vkURL + "photos.getAll"
        let params = ["access_token": token,
                      "owner_id": ownerId,
                      "no_service_albums": "0",
                      "extended": "1",
                      "photo_sizes": "1",
                      "v": version] as [String : Any]
        
        requestServer(requestURL: requestURL, method: .post, params: params) { completion($0) }
    }
    
    func getGroupListForUser(token: String, version: String, user: String, completion: @escaping (Swift.Result<[GroupVK], Error>) -> Void ) {
        let requestURL = vkURL + "groups.get"
        let params = ["access_token": token,
                      "user_id": user,
                      "extended": "1",
                      "fields": "photo_100",
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
    
    func getNews(token: String, userId:String, from: String?, version: String, completion: @escaping (Swift.Result<ResponseNews, Error>) -> Void ) {
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
                    completion(.failure(error))
                }
        }
    }
    
}
