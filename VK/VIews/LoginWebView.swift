import UIKit
import Alamofire
import WebKit

class LoginWebView: UIViewController {
    
    private let vkSecret = "7286112"
    var webView: WKWebView!
    var vkApi = VKApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webViewConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webViewConfig)
        webView.navigationDelegate = self
        
        /*
        //реализация с URLComponent
        var urlVkComponent = URLComponents()
        urlVkComponent.scheme = "https"
        urlVkComponent.host = "oauth.vk.com"
        urlVkComponent.path = "/authorize"
        urlVkComponent.queryItems = [URLQueryItem(name: "client_id", value: vkSecret),
                                     URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                                     URLQueryItem(name: "display", value: "mobile"),
                                     URLQueryItem(name: "scope", value: "262150"),
                                     URLQueryItem(name: "response_type", value: "token"),
                                     URLQueryItem(name: "v", value: "5.103")]
        
        let request = URLRequest(url: urlVkComponent.url!)
        webView.load(request)
        view = webView
        */
        
        //реализация с Alamofire
        let params = ["client_id": vkSecret,
                      "redirect_uri": "https://oauth.vk.com/blank.html",
                      "display": "mobile",
                      "scope": "262150",
                      "response_type": "token",
                      "v": "5.103"]
        
        let dataRequest = Alamofire.request("https://oauth.vk.com/authorize",
                                            method: .post,
                                            parameters: params)
        //безопасно извлекаем тип данных URLRequest? из DataRequest при помощи .request
        guard let urlRequest = dataRequest.request else { return }
        webView.load(urlRequest)
        view = webView
    }
    
    func pushMainView() {
        let main = UIStoryboard( name: "Main", bundle: nil)
        let vc = main.instantiateViewController(identifier: "MainView") as! ProfileForm
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginWebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        //делаем системные переходы внутри vk до тех пор пока не перейдем на blank.html
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html", let fragment = url.fragment else {
                //разрешаем переходы
                decisionHandler(.allow)
                return
        }
        
        //перейдя на blank.html сохраняем полученные данные в словарь
        let params = fragment.components(separatedBy: "&")
            .map{ $0.components(separatedBy: "=")}
            .reduce([String: String]()) {
                value, params in
                var dict = value
                let key = params[0]
                let value = params[1]
                dict[key] = value
                return dict
        }
        
        //безопасно извлекаем token и user_id
        guard let token = params["access_token"],
            let userId = params["user_id"] else {
                //сделаем вывод оповещения при невозможности извлечения token и user_id
                let alert = UIAlertController(title: "Error", message: "Authorization error", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
                print("[Logging] authorization error")
                
                return
        }
        //присваиваем значения нашему singleton instance
        Session.instance.token = token
        Session.instance.userId = userId
        Session.instance.version = "5.103"
        
        print("[Logging] token = \(Session.instance.token)")
        print("[Logging] user_id = \(Session.instance.userId)")
        /*
        //запрос списка друзей текущего пользователя
        vkApi.getFriendList(token: Session.instance.token)
        //запрос фотографий конкретного пользователи и конкретного альбома
        vkApi.getPhotoInAlbum(token: Session.instance.token, user: Session.instance.userId, album: .profile)
        //запрос списка групп конкретного пользователя
        vkApi.getGroupListForUser(token: Session.instance.token, user: Session.instance.userId)
        //поиск групп по ключевым словам
        vkApi.getFilteredGroupList(token: Session.instance.token, user: Session.instance.userId, text: "Swift Develop")
        */
        //запрещаем переходы
        decisionHandler(.cancel)
        
        pushMainView()
    }
}
