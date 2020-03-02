//
//  NewsPresenter.swift
//  VK
//
//  Created by Дмитрий Константинов on 24.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation
import RealmSwift

protocol NewsPresenter {
    func viewDidLoad()
    func uploadData()
    func searchNews(text: String)
    
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    func getModelAtIndex(indexPath: IndexPath) -> NewsRealm?
}

class NewsPresenterImplementation: NewsPresenter {
   
    private var vkApi: VKApi
    private var database: NewsSource
    private weak var view: NewsTableViewControllerUpdater?
    private var newsResult: Results<NewsRealm>!
    private var token: NotificationToken?
    private var nextFrom = ""
    private var status = false
    
    init(database: NewsSource, view: NewsTableViewControllerUpdater) {
        vkApi = VKApi()
        self.database = database
        self.view = view
    }
    
    deinit {
        token?.invalidate()
        do {
            try database.saveLastNews()
        } catch {
            print(error)
        }
    }
    
    func viewDidLoad() {
        getNewsFromApi()
    }
    
    func uploadData() {
        if status {
            status = false
            getNewsFromApi(from: nextFrom)
        }
    }

    func searchNews(text: String) {
        do {
            newsResult = text.isEmpty ? try database.getAllNews() : try database.searchNews(text: text)
            tokenInitializaion()
        } catch {
            print(error)
        }
    }
    
    private func getNewsFromApi(from: String? = nil) {
        
        vkApi.getNewsList(token: Session.instance.token, userId: Session.instance.userId, from: from, version: Session.instance.version) { result in
            switch result {
            case .success(let result):
                let posts = result.items.compactMap {
                    self.postCreation(news: $0, profiles: result.profiles, groups: result.groups)
                }
//                var posts = [PostVK]()
//                result.items.forEach {
//                    if let post = self.postCreation(news: $0, profiles: result.profiles, groups: result.groups) { posts.append(post) }
//                }

                self.database.addNews(posts: posts)
                self.getNewsFromDatabase()
                if let nextFrom = result.nextFrom {
                    self.nextFrom = nextFrom
                }
                self.status = true
            case .failure(let error):
                self.view?.showConnectionAlert()
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
    }
    
    private func getNextFrom() -> String? {
        return nextFrom
    }
    
    private func getNewsFromDatabase() {
        do {
            newsResult = try database.getAllNews()
            tokenInitializaion()
        } catch {
            print(error)
        }
    }
    
    private func tokenInitializaion() {
    
        token = newsResult?.observe { [weak self] results in
            switch results {
            case .error(let error):
                print(error)
            case .initial:
                self?.view?.reloadTable()
            case let .update(_, deletions, insertions, modifications):
                self?.view?.updateTable(forDel: deletions, forIns: insertions, forMod: modifications)
            }
        }
    }
    
    private func postCreation(news: NewsVK, profiles: [UserVK], groups: [GroupVK]) -> PostVK? {
        
        var post = PostVK(text: "", likes: 0, userLikes: 0, views: 0, comments: 0, reposts: 0, date: 0, authorImagePath: "", authorName: "", photos: [])
        var photos = [String]()
        
        post.text = news.text
        post.likes = news.likes.count
        post.userLikes = news.likes.userLikes
        if let views = news.views?.count {
            post.views = views
        } else {
            post.views = 0
        }
        post.comments = news.comments.count
        post.reposts = news.reposts.count
        post.date = news.date
        
        //new methods
        if let source = news.sourceId {
            if source > 0 {
                profiles.forEach { if $0.id == source {
                    post.authorName = $0.fullname
                    post.authorImagePath = $0.photo100
                    }
                }
            }
            if source < 0 {
                groups.forEach { if $0.id == -source {
                    post.authorName = $0.name
                    post.authorImagePath = $0.photo100
                    }
                }
            }
        }
        
        if let attachments = news.attachments {
            for attachment in attachments {
                if attachment.type == "photo" {
                    attachment.photo?.sizes.forEach {
                        if $0.type == "r" {
                            photos.append($0.url)
                        }
                    }
                }
            }
        }
        
        post.photos = photos
        
        if post.text == "", post.photos == [] {
            return nil
        }
        
        return post
    }
}

extension NewsPresenterImplementation {
    
    func getModelAtIndex(indexPath: IndexPath) -> NewsRealm? {
        return newsResult?[indexPath.row]
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return newsResult?.count ?? 0
    }
    
}
