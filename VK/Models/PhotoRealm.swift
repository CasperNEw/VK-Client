import Foundation
import RealmSwift

class PhotoRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var albumID = ""
    @objc dynamic var ownerID = 0

    @objc dynamic var text = ""
    @objc dynamic var date = ""
    @objc dynamic var postID = ""
    @objc dynamic var likeSelf = 0
    @objc dynamic var likesCount = 0
    @objc dynamic var repostsCount = 0
    @objc dynamic var commentsCount = 0
    @objc dynamic var canComment = 0
    @objc dynamic var tagsCount = 0
}

class PhotoSizesRealm: Object {
    @objc dynamic var id = 0 //добавляем id фотографии что бы потом можно было понять что откуда и куда
    @objc dynamic var type = "" //case s, m, x, o, p, q, r, y, z, w
    @objc dynamic var url = ""
    @objc dynamic var width = 0
    @objc dynamic var height = 0
    
    //dynamic var photo: PhotoRealm! //привязываем каждый объект с данными к классу нашей фотографии
}

class PhotoRepositoryRealm {
    
    var photoRealm: PhotoRealm!
    var photoSizesRealm: PhotoSizesRealm!
    
    
    func addPhoto(id: Int, albumID: String, ownerID: Int, text: String, date: String, postID: String, likeSelf: Int, likesCount: Int, repostsCount: Int, commentsCount: Int, canComment: Int, tagsCount: Int) {
        
        let realm = try? Realm()
        let newPhoto = PhotoRealm()
        
        newPhoto.id = id
        newPhoto.albumID = albumID
        newPhoto.ownerID = ownerID

        newPhoto.text = text
        newPhoto.date = date
        newPhoto.postID = postID
        newPhoto.likeSelf = likeSelf
        newPhoto.likesCount = likesCount
        newPhoto.repostsCount = repostsCount
        newPhoto.commentsCount = commentsCount
        newPhoto.canComment = canComment
        newPhoto.tagsCount = tagsCount
      
        try? realm?.write {
            realm?.add(newPhoto)
            self.photoRealm = newPhoto
        }
    }
    
    func getPhoto(id: Int) -> PhotoRealm? {
        let realm = try! Realm()
        return realm.objects(PhotoRealm.self).filter("id == %@", id).first
    }
    
    func updatePhoto(id: Int, albumID: String, ownerID: Int, text: String, date: String, postID: String, likeSelf: Int, likesCount: Int, repostsCount: Int, commentsCount: Int, canComment: Int, tagsCount: Int) {
        
        let realm = try! Realm()
        try! realm.write {
            
            self.photoRealm.id = id
            self.photoRealm.albumID = albumID
            self.photoRealm.ownerID = ownerID

            self.photoRealm.text = text
            self.photoRealm.date = date
            self.photoRealm.postID = postID
            self.photoRealm.likeSelf = likeSelf
            self.photoRealm.likesCount = likesCount
            self.photoRealm.repostsCount = repostsCount
            self.photoRealm.commentsCount = commentsCount
            self.photoRealm.canComment = canComment
            self.photoRealm.tagsCount = tagsCount
        }
    }
    
    func getAllPhotos() -> Results<PhotoRealm> {
        let realm = try! Realm()
        return realm.objects(PhotoRealm.self)
    }
    
    func addPhotoSizes(id: Int, type: String, url: String, width: Int, height: Int) {
        
        let realm = try? Realm()
        let newPhotoSizes = PhotoSizesRealm()
        
        newPhotoSizes.id = id
        newPhotoSizes.type = type //case s, m, x, o, p, q, r, y, z, w
        newPhotoSizes.url = url
        newPhotoSizes.width = width
        newPhotoSizes.height = height
       
        try? realm?.write {
            realm?.add(newPhotoSizes)
            self.photoSizesRealm = newPhotoSizes
        }
    }
    
    func getPhotoSizes(id: Int, type: String) -> PhotoSizesRealm? {
        let realm = try! Realm()
        return realm.objects(PhotoSizesRealm.self).filter("id == %@", id).filter("type == %@", type).first
    }
    
    func updatePhotoSizes(id: Int, type: String, url: String, width: Int, height: Int) {
        
        let realm = try! Realm()
        try! realm.write {
            
            self.photoSizesRealm.id = id
            self.photoSizesRealm.type = type
            self.photoSizesRealm.url = url
            self.photoSizesRealm.width = width
            self.photoSizesRealm.height = height
        }
    }
    
    func getAllPhotosSizes(id: Int) -> Results<PhotoSizesRealm> {
        let realm = try! Realm()
        return realm.objects(PhotoSizesRealm.self).filter("id == %@", id)
    }
}
