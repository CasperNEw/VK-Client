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
    func filterContent(searchText: String)
    
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    func getModelAtIndex(indexPath: IndexPath) -> NewsCell?
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
    
    func filterContent(searchText: String) {
        do {
            newsResult = searchText.isEmpty ? try database.getAllNews() : try database.searchNews(text: searchText)
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
                self.database.addNews(posts: posts)
                self.getNewsFromDatabase()
                if let nextFrom = result.nextFrom {
                    self.nextFrom = nextFrom
                }
                self.status = true
            case .failure(let error):
                self.view?.endRefreshing()
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
            self.view?.endRefreshing()
            tokenInitializaion()
        } catch {
            self.view?.endRefreshing()
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
        
        getPostAuthor(news: news, profiles: profiles, groups: groups, post: &post)
        getPostPhotos(news: news, post: &post)
        
        if post.text == "", post.photos == [] { return nil }
        return post
    }
    
    private func getPostAuthor(news: NewsVK, profiles: [UserVK], groups: [GroupVK], post: inout PostVK) {
        
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
    }
    
    private func getPostPhotos(news: NewsVK, post: inout PostVK) {
        
        if let attachments = news.attachments {
            for attachment in attachments {
                if attachment.type == "photo" {
                    attachment.photo?.sizes.forEach {
                        if $0.type == "r" {
                            post.photos.append($0.url)
                        }
                    }
                }
            }
        }
    }
}

extension NewsPresenterImplementation {
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return newsResult?.count ?? 0
    }
    
}

extension NewsPresenterImplementation {
    
    func getModelAtIndex(indexPath: IndexPath) -> NewsCell? {
        return renderWallRealmToNewsCell(news: newsResult?[indexPath.row])
    }
    
    private func renderWallRealmToNewsCell(news: NewsRealm?) -> NewsCell? {
        
        guard let news = news else { return nil }
        var cellModel = NewsCell()
        
        cellModel.mainAuthorImage = news.authorImagePath
        cellModel.mainAuthorName = news.authorName
        cellModel.publicationDate = prepareDate(modelDate: news.date)
        cellModel.publicationText = news.text
        cellModel.publicationLikeButtonStatus = news.userLikes == 1 ? true : false
        cellModel.publicationLikeButtonCount = news.likes
        cellModel.publicationCommentButton = prepareCount(modelCount: news.comments)
        cellModel.publicationForwardButton = prepareCount(modelCount: news.reposts)
        cellModel.publicationNumberOfViews = prepareCount(modelCount: news.views)
        
        cellModel.newsCollectionViewIsEmpty = news.photos.isEmpty
        news.photos.forEach { if let url = URL(string: $0) { cellModel.photoCollection.append(url)}}
        
        return cellModel
    }
    
    private func prepareDate(modelDate: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM в HH:mm"
        formatter.locale = Locale(identifier: "ru")
        let date = Date(timeIntervalSince1970: Double(modelDate))
        return formatter.string(from: date)
    }
    
    private func prepareCount(modelCount: Int) -> String {
        let count = modelCount
        if count < 1000 {
            return "\(modelCount)"
        } else if count < 10000 {
            return String(format: "%.1fK", Float(count) / 1000)
        } else {
            return String(format: "%.0fK", floorf(Float(count) / 1000))
        }
    }
}
