//
//  FriendsPresenter.swift
//  VK
//
//  Created by Дмитрий Константинов on 01.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation
import RealmSwift

struct Section<T> {
    var title: String
    var items: [T]
}

protocol FriendsPresenter {
    
    func viewDidLoad()
    func refreshTable()
    func filterContent(searchText: String)
    func sendToNextVC(indexPath: IndexPath) -> Int
    
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    func getSectionIndexTitles() -> [String]?
    func getTitleForSection(section: Int) -> String?
    func getModelAtIndex(indexPath: IndexPath) -> FriendsCellModel?
    
    init(view: FriendsTableViewControllerUpdater)
}

class FriendsPresenterImplementation: FriendsPresenter {
    
    private var vkApi: VKApi
    private var database: UserSourse
    private weak var view: FriendsTableViewControllerUpdater?
    private var friendsResult: Results<UserRealm>!
    private var friendsWithSectionsResults = [Section<UserRealm>]()
    
    required init(view: FriendsTableViewControllerUpdater) {
        vkApi = VKApi()
        database = UserRepository()
        self.view = view
    }
    
    func viewDidLoad() {
        getUsersFromDatabase()
        getUsersFromApi()
    }
    
    func refreshTable() {
        getUsersFromApi()
    }
    
    func filterContent(searchText: String) {
        do {
            self.friendsResult = searchText.isEmpty ? try database.getAllUsers() : try database.searchUsers(name: searchText)
            if searchText == "Online" { self.friendsResult = try database.getOnline() }
            
            let friendsDictionary = Dictionary(grouping : friendsResult) { $0.lastName.prefix(1) }
            friendsWithSectionsResults = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
            friendsWithSectionsResults.sort { $0.title < $1.title }
            self.view?.updateTable()
        } catch {
            print(error)
        }
    }
    
    func sendToNextVC(indexPath: IndexPath) -> Int {
        return friendsWithSectionsResults[indexPath.section].items[indexPath.row].id
    }

    private func getUsersFromDatabase() {
        do {
            self.friendsResult = try database.getAllUsers()

            self.makeSortedSection()
            self.view?.endRefreshing()
            self.view?.updateTable()
        } catch {
            self.view?.endRefreshing()
            print(error)
        }
    }
    
    private func getUsersFromApi() {
        vkApi.getFriendList(token: Session.instance.token, version: Session.instance.version) { [weak self] result in
            switch result {
            case .success(let users):
                self?.database.addUsers(users: users)
                self?.getUsersFromDatabase()
            case .failure(let error):
                self?.view?.endRefreshing()
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
    }
    
    private func makeSortedSection() {
        let friendsDictionary = Dictionary.init(grouping: friendsResult ) { $0.lastName.prefix(1) }
        friendsWithSectionsResults = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendsWithSectionsResults.sort { $0.title < $1.title }
    }
    
        
}

extension FriendsPresenterImplementation {
    
    func getNumberOfSections() -> Int {
        return friendsWithSectionsResults.count
    }
    
    func getSectionIndexTitles() -> [String]? {
        return friendsWithSectionsResults.map { $0.title }
    }
    
    func getTitleForSection(section: Int) -> String? {
        return friendsWithSectionsResults[section].title
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return friendsWithSectionsResults[section].items.count
    }
}

extension FriendsPresenterImplementation {
    
    func getModelAtIndex(indexPath: IndexPath) -> FriendsCellModel? {
        return renderUserRealmToFriendsCell(user: friendsWithSectionsResults[indexPath.section].items[indexPath.row])
    }
    
    private func renderUserRealmToFriendsCell(user: UserRealm?) -> FriendsCellModel? {
        guard let user = user else { return nil }
        
        var friendsName = user.firstName + " " + user.lastName
        if user.online == 1 { friendsName += " * online" }
        
        let cellModel = FriendsCellModel(friendsName: friendsName, cornerShadowView: user.photo100)
        
        return cellModel
    }
}
