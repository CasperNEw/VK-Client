//
//  PhotoRepository.swift
//  VK
//
//  Created by Дмитрий Константинов on 02.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation
import RealmSwift

class PhotoRepository {
    
    func getAllPhotos() throws -> Results<PhotoRealm> {
        do {
            let realm = try Realm()
            return realm.objects(PhotoRealm.self)
        } catch {
            throw error
        }
    }
    
    func addPhotos(photos: [PhotoVK]) {
        do {
            let realm = try! Realm()
            
            try realm.write() {
                var photosToAdd = [PhotoRealm]()
                photos.forEach { photo in
                    let photoRealm = PhotoRealm()
                    
                    photoRealm.id = photo.id
                    photoRealm.albumID = photo.albumID
                    photoRealm.ownerID = photo.ownerID
                    photoRealm.text = photo.text
                    photoRealm.date = photo.date
                    
                    photoRealm.userLikes = photo.likes.userLikes
                    photoRealm.likesCount = photo.likes.count
                    photoRealm.repostsCount = photo.reposts.count
                    
                    photoRealm.sizes.append(objectsIn: photo.sizes.map{ $0.toRealm() })
                    
                    photosToAdd.append(photoRealm)
                }
                realm.add(photosToAdd, update: .modified)
            }
            //print(realm.objects(PhotoRealm.self))
        } catch {
            print(error)
        }
    }

    //метод возврата фотографий содержащихся в определенном альбоме ( albumID )
    func getAlbum(albumID: Int) throws -> Results<PhotoRealm> {
        do {
            let realm = try Realm()
            return realm.objects(PhotoRealm.self).filter("albumID == %@", albumID)
        } catch {
            throw error
        }
    }
}

