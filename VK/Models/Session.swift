import UIKit

class Session {
    
    static let instance = Session()
    private init() {}
    
    var userId = ""
    var token = ""
    var version = ""
}
