//
//  NewsRepository.swift
//  VK
//
//  Created by Дмитрий Константинов on 24.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import RealmSwift

protocol NewsSource {
    func getAllNews() throws -> Results<NewsRealm>
    func addNews(posts: [PostVK])
    func searchNews(text: String) throws -> Results<NewsRealm>
    func saveLastNews() throws
}

class NewsRepository: NewsSource {
    
    func getAllNews() throws -> Results<NewsRealm> {
        do {
            let realm = try Realm()
            return realm.objects(NewsRealm.self)
        } catch {
            throw error
        }
    }
    
    func addNews(posts: [PostVK]) {
        do {
            let realm = try Realm()
            try realm.write {
                var newsToAdd = [NewsRealm]()
                posts.forEach { post in
                    let postRealm = NewsRealm()
                    postRealm.text = post.text
                    postRealm.likes = post.likes
                    postRealm.userLikes = post.userLikes
                    postRealm.views = post.views
                    postRealm.comments = post.comments
                    postRealm.reposts = post.reposts
                    postRealm.date = post.date
                    postRealm.authorImagePath = post.authorImagePath
                    postRealm.authorName = post.authorName
                    post.photos.forEach { postRealm.photos.append($0)  }
                    newsToAdd.append(postRealm)
                }
                realm.add(newsToAdd, update: .modified)
                print("[Logging] NewsRealm get entities - \(newsToAdd.count)")
            }
        } catch {
            print(error)
        }
    }
    
    func searchNews(text: String) throws -> Results<NewsRealm> {
        do {
            let realm = try Realm()
            return realm.objects(NewsRealm.self).filter("text CONTAINS[c] %@", text)
        } catch {
            throw error
        }
    }
    
    func saveLastNews() throws {
        print("[Logging] SAVE NEWS")
        do {
            let realm = try Realm()
            let news = realm.objects(NewsRealm.self).sorted(byKeyPath: "date")
        
            if news.count > 20 {
                var newsToSave = [NewsRealm]()
                for i in 1...20 {
                    newsToSave.append(news[news.count - i])
                }
                try realm.write {
                    realm.delete(realm.objects(NewsRealm.self))
                    realm.add(newsToSave, update: .modified)
                }
            }
        } catch {
            throw error
        }
    }
}
