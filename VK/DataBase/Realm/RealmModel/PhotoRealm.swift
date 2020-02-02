import Foundation
import RealmSwift

class PhotoRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var albumID = 0
    @objc dynamic var ownerID = 0
    @objc dynamic var text = ""
    @objc dynamic var date = 0
    
    //мы получаем объекты Likes Reposts из Api, но мы можем представить всё просто в виде переменных
    @objc dynamic var userLikes = 0
    @objc dynamic var likesCount = 0
    @objc dynamic var repostsCount = 0
    
    var sizes = List<PhotoSizesRealm>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    func toModel() -> PhotoVK {
        
        var sizes = [PhotoSize]()
        //Формируем массив размеров sizes для каждой фотографии
        sizes.forEach { size in
            let oneSize = PhotoSize(type: size.type, url: size.url, width: size.width, height: size.height)
            sizes.append(oneSize)
        }
        //наполняем структуры объектов likes и resposts
        let likes = PhotoLikes(userLikes: self.userLikes, count: self.likesCount)
        let reposts = PhotoReposts(count: self.repostsCount)
        
        return PhotoVK(id: id, albumID: albumID, ownerID: ownerID, sizes: sizes, text: text, date: date, likes: likes, reposts: reposts)
    
    }
}

class PhotoSizesRealm: Object {
    @objc dynamic var type = "" //case s, m, x, o, p, q, r, y, z, w
    @objc dynamic var url = ""
    @objc dynamic var width = 0
    @objc dynamic var height = 0
    
    //dynamic var photo: PhotoRealm! //привязываем каждый объект с данными к классу нашей фотографии
}
