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
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    func getModelAtIndex(indexPath: IndexPath) -> ProfileRealm?
}

class ProfilePresenterImplementation: ProfilePresenter {
    
    private var vkApi: VKApi
    private var database: ProfileSource
    private weak var view: ProfileTableViewUpdater?
    private var profileResult: Results<ProfileRealm>!
    private var token: NotificationToken?
    
    init(database: ProfileSource, view: ProfileTableViewUpdater) {
        vkApi = VKApi()
        self.database = database
        self.view = view
    }
    
    deinit {
        token?.invalidate()
    }
    
    func viewDidLoad(fromVC: Int?) {
        getProfileFromApi(id: fromVC)
    }
    
    private func getProfileFromApi(id: Int?) {
        
        var idForRequest = Session.instance.userId
        id != nil ? idForRequest = String(id!) : view?.showIncorrectDataAlert()
        
        vkApi.getUser(token: Session.instance.token, userId: idForRequest) { [weak self] result in
            switch result {
            case .success(let result):
                if let user = result.first {
                    
                    self?.vkApi.getUserPhoto(token: Session.instance.token, version: Session.instance.version, ownerId: idForRequest) { result in
                        switch result {
                        case .success(let result):
                            
                            if let profile = self?.profileCreation(user: user, photos: result) {
                                self?.database.addProfile(profile: profile)
                                self?.getProfileFromDatabase(id: idForRequest)
                            }
                        case .failure(let error):
                            self?.view?.showConnectionAlert()
                            print("[Logging] Error retrieving the value: \(error)")
                        }
                    }
                }
            case .failure(let error):
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
            tokenInitializaion()
        } catch {
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
    
    private func tokenInitializaion() {
        
        token = profileResult?.observe { [weak self] results in
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
    
    private func profileCreation(user: AdvancedUserVK, photos: [PhotoVK]) -> ProfileVK {
        
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
}

extension ProfilePresenterImplementation {
    
    func getModelAtIndex(indexPath: IndexPath) -> ProfileRealm? {
        return profileResult?.first
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return  1
    }
}
