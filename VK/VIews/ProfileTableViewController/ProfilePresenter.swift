//
//  ProfilePresenter.swift
//  VK
//
//  Created by Дмитрий Константинов on 19.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation
import RealmSwift
import Kingfisher

protocol ProfilePresenter {

    func viewDidLoad(fromVC: Int?)
    func uploadData(fromVC: Int?)
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    func getModel() -> ProfileRealm?
    func getWallModelAtIndex(indexPath: IndexPath) -> WallRealm?
}

class ProfilePresenterImplementation: ProfilePresenter {
    
    private var vkApi: VKApi
    private var database: ProfileSource
    private var databaseWall: WallSource
    private weak var view: ProfileTableViewControllerUpdater?
    private var profileResult: Results<ProfileRealm>!
    private var wallResult: Results<WallRealm>!
    private var token: NotificationToken?
    private var wallToken: NotificationToken?
    
    private var offset = 0
    private var status = false
    
    init(database: ProfileSource, databaseWall: WallSource, view: ProfileTableViewControllerUpdater) {
        vkApi = VKApi()
        self.database = database
        self.databaseWall = databaseWall
        self.view = view
    }
    
    deinit {
        token?.invalidate()
        wallToken?.invalidate()
        do {
            try databaseWall.deleteWall()
        } catch {
            print(error)
        }
    }
    
    func viewDidLoad(fromVC: Int?) {
        getProfileFromApi(id: fromVC)
        getWallFromApi(id: fromVC)
    }
    
    func uploadData(fromVC: Int?) {
        if status {
            status = false
            getWallFromApi(id: fromVC, offset: offset)
        }
    }
    
    private func getProfileFromApi(id: Int?) {
        
        if id ?? 0 < 0 {
            guard let testId = id else { return }
            let groupId = String(-testId)
            
            vkApi.getGroup(token: Session.instance.token, groupId: groupId, version: Session.instance.version) { [weak self] result in
                switch result {
                case .success(let result):
                    if let group = result.first {
                        if let profile = self?.creatingGroupProfileFromData(group: group) {
                            self?.database.addProfile(profile: profile)
                            self?.getProfileFromDatabase(id: groupId)
                        }
                    }
                case .failure(let error):
                    self?.view?.endRefreshing()
                    self?.view?.showConnectionAlert()
                    print("[Logging] Error retrieving the value: \(error)")
                }
            }
            return
        }
        
        var idForRequest = Session.instance.userId
        id != nil ? idForRequest = String(id!) : nil
        
        vkApi.getUser(token: Session.instance.token, userId: idForRequest, version: Session.instance.version) { [weak self] result in
            switch result {
            case .success(let result):
                if let user = result.first {
                    
                    self?.vkApi.getUserPhoto(token: Session.instance.token, version: Session.instance.version, ownerId: idForRequest) { result in
                        switch result {
                        case .success(let result):
                            
                            if let profile = self?.creatingUserProfileFromData(user: user, photos: result) {
                                self?.database.addProfile(profile: profile)
                                self?.getProfileFromDatabase(id: idForRequest)
                            }
                        case .failure(let error):
                            self?.view?.endRefreshing()
                            self?.view?.showConnectionAlert()
                            print("[Logging] Error retrieving the value: \(error)")
                        }
                    }
                }
            case .failure(let error):
                self?.view?.endRefreshing()
                self?.view?.showConnectionAlert()
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
    }
    
    private func getProfileFromDatabase(id: String) {
        do {
            guard let idForRequest = Int(id) else { return }
            profileResult = try database.getProfile(id: idForRequest)
            if let model = profileResult.first?.toModel() {
                getProfileImageData(profile: model)
            }
            self.view?.endRefreshing()
            self.view?.reloadTable()
        } catch {
            self.view?.endRefreshing()
            print(error)
        }
    }
    
    private func getWallFromApi(id: Int?, offset: Int? = 0) {
        
        var idForRequest = Session.instance.userId
        id != nil ? idForRequest = String(id!) : nil
        if offset == nil { self.offset = 0 }
        
        vkApi.getWall(token: Session.instance.token, ownerId: idForRequest, version: Session.instance.version, offset: offset ?? 0) { result in
            switch result {
            case .success(let result):
                var posts = [PostVK]()
                result.items.forEach {
                    if let post = self.creatingPostFromData(news: $0, profiles: result.profiles, groups: result.groups) { posts.append(post) }
                }
                self.databaseWall.addWall(posts: posts)
                self.getWallFromDatabase(id: idForRequest)
                if result.items.count == 20 {
                    self.status = true
                    self.offset += 20
                }
            case .failure(let error):
                self.view?.endRefreshing()
                self.view?.showConnectionAlert()
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
    }
    
    private func getWallFromDatabase(id: String) {
        do {
            guard let idForRequest = Int(id) else { return }
            wallResult = try databaseWall.getWall(ownerId: idForRequest)
            self.view?.endRefreshing()
            self.view?.reloadTable()
        } catch {
            self.view?.endRefreshing()
            print(error)
        }

    }
    
    private func getProfileImageData(profile: ProfileVK) {
        
        if let url = URL(string: profile.photoPath) {
            
            let width = (profile.photoRectX2 - profile.photoRectX1) / 100 * profile.photoWidth
            let height = (profile.photoRectY2 - profile.photoRectY1) / 100 * profile.photoHeight
            let x = profile.photoRectX1 / 100
            let y = profile.photoRectY1 / 100
            
            let processor = CroppingImageProcessor(size: CGSize(width: width, height: height), anchor: CGPoint(x: x, y: y))
            
            let name = profile.fullname
            
            if profile.lastSeenTime == 0 {
                view?.setupProfileImage(name: name, date: "", url: url, processor: processor)
                return
            }
            
            let date = prepareLastSeen(online: profile.online, lastSeen: profile.lastSeenTime)
            view?.setupProfileImage(name: name, date: date, url: url, processor: processor)
        }
    }
    
    private func prepareLastSeen(online: Int, lastSeen: Int) -> String {
        
        if online == 1 { return "online" }
        let formatter = DateFormatter()
        formatter.dateFormat = "Был в сети d MMMM в HH:mm"
        formatter.locale = Locale(identifier: "ru")
        let date = Date(timeIntervalSince1970: Double(lastSeen))
        return formatter.string(from: date)
    }
    
    private func creatingUserProfileFromData(user: AdvancedUserVK, photos: [PhotoVK]) -> ProfileVK {
        
        var profile = ProfileVK(id: 0, firstName: "", lastName: "", online: 0, lastSeenTime: 0, lastSeenPlatform: 0, status: "", friendsCount: 0, mutualFriendsCount: 0, followersCount: 0, city: "", career: "", photoPath: "", photoWidth: 0.0, photoHeight: 0.0, photoRectX1: 0.0, photoRectY1: 0.0, photoRectX2: 0.0, photoRectY2: 0.0, photos: [])
        
        profile.id = user.id
        profile .firstName = user.firstName
        profile.lastName = user.lastName
        profile.online = user.online
        profile.lastSeenTime = user.lastSeen.time
        profile.lastSeenPlatform = user.lastSeen.platform
        profile.status = user.status ?? ""
        profile.friendsCount = user.counters.friends ?? 0
        profile.mutualFriendsCount = user.counters.mutualFriends ?? 0
        profile.followersCount = user.counters.followers ?? 0
        profile.city = user.city?.title ?? ""
        profile.career = user.career?.first?.company ?? ""
        
        user.cropPhoto?.photo.sizes.forEach {
            if $0.type == "r" {
                profile.photoPath = $0.url
                profile.photoWidth = Double($0.width)
                profile.photoHeight = Double($0.height)
            }
        }
        profile.photoRectX1 = user.cropPhoto?.rect.x ?? 0.0
        profile.photoRectY1 = user.cropPhoto?.rect.y ?? 0.0
        profile.photoRectX2 = user.cropPhoto?.rect.x2 ?? 0.0
        profile.photoRectY2 = user.cropPhoto?.rect.y2 ?? 0.0
        
        photos.forEach {
            $0.sizes.forEach {
                if $0.type == "r" {
                    profile.photos.append($0.url)
                }
            }
        }
        
        return profile
    }
    
    private func creatingGroupProfileFromData(group: AdvancedGroupVK) -> ProfileVK {
        
        var profile = ProfileVK(id: 0, firstName: "", lastName: "", online: 0, lastSeenTime: 0, lastSeenPlatform: 0, status: "", friendsCount: 0, mutualFriendsCount: 0, followersCount: 0, city: "", career: "", photoPath: "", photoWidth: 0.0, photoHeight: 0.0, photoRectX1: 0.0, photoRectY1: 0.0, photoRectX2: 0.0, photoRectY2: 0.0, photos: [])
        
        profile.id = group.id
        profile.firstName = group.name
        profile.followersCount = group.membersCount
        profile.city = group.city?.title ?? "vk.com"
        profile.career = group.site
        if profile.career == "" { profile.career = group.screenName }
        
        group.cropPhoto?.photo.sizes.forEach {
            if $0.type == "r" {
                profile.photoPath = $0.url
                profile.photoWidth = Double($0.width)
                profile.photoHeight = Double($0.height)
            }
        }
        
        if profile.photoPath == "" {
            profile.photoPath = group.photo100
            profile.photoWidth = Double(100)
            profile.photoHeight = Double(100)
        }
        
        profile.photoRectX1 = group.cropPhoto?.rect.x ?? 0.0
        profile.photoRectY1 = group.cropPhoto?.rect.y ?? 0.0
        profile.photoRectX2 = group.cropPhoto?.rect.x2 ?? 100.0
        profile.photoRectY2 = group.cropPhoto?.rect.y2 ?? 100.0
        
        return profile
    }
    
    private func creatingPostFromData(news: NewsVK, profiles: [UserVK], groups: [GroupVK]) -> PostVK? {
        
        var post = PostVK(id: 0, ownerId: 0, text: "", likes: 0, userLikes: 0, views: 0, comments: 0, reposts: 0, date: 0, authorImagePath: "", authorName: "", photos: [])
        
        post.id = news.id
        post.ownerId = news.ownerId
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
        
        if let source = news.fromId {
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

extension ProfilePresenterImplementation {
    
    func getModel() -> ProfileRealm? {
        return profileResult?.first
    }
    
    func getWallModelAtIndex(indexPath: IndexPath) -> WallRealm? {
        return wallResult?[indexPath.row - 1]
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return (profileResult?.count ?? 0) + (wallResult?.count ?? 0)
    }
}
