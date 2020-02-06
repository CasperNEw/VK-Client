//
//  FriendsPresenter.swift
//  VK
//
//  Created by Дмитрий Константинов on 01.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation
import RealmSwift

protocol FriendsPresenter {
    
    func viewDidLoad()
    func apiRequest()
    func searchFriends(name: String)
    
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    func getSectionIndexTitles() -> [String]?
    func getTitleForSection(section: Int) -> String?
    func getModelAtIndex(indexPath: IndexPath) -> UserRealm?
}

class FriendsPresenterImplementation: FriendsPresenter {
    
    private var vkApi: VKApi
    private var database: UserSourse
    private weak var view: FriendsTableViewUpdater?
    private var friendsResult: Results<UserRealm>!
    private var friendsWithSectionsResults = [Section<UserRealm>]()
    
    init(database: UserSourse, view: FriendsTableViewUpdater) {
        vkApi = VKApi()
        self.database = database
        self.view = view
    }
    
    func viewDidLoad() {
        getUsersFromDatabase()
        getUsersFromApi()
    }
    
    func apiRequest() {
        //принудительное обновление
        getUsersFromApi()
    }
    
    func searchFriends(name: String) {
        do {
            self.friendsResult = name.isEmpty ? try database.getAllUsers() : try database.searchUsers(name: name)
            
            let friendsDictionary = Dictionary(grouping : friendsResult) { $0.lastName.prefix(1) }
            friendsWithSectionsResults = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
            friendsWithSectionsResults.sort { $0.title < $1.title }
            self.view?.updateTable()
        } catch {
            print(error)
        }
    }

    private func getUsersFromDatabase() {
        do {
            self.friendsResult = try database.getAllUsers()
            self.makeSortedSection()
            self.view?.updateTable()
        } catch {
            print(error)
        }
        /* //or use CoreData database ... ?!
        self.dataFriends = presenterCD.getUsersFromDatabase()
        self.makeSortedSection()
        */
    }
    
    private func getUsersFromApi() {
        vkApi.getFriendList(token: Session.instance.token, version: Session.instance.version) { result in
            switch result {
            case .success(let users):
                self.database.addUsers(users: users)
                self.getUsersFromDatabase()
            case .failure(let error):
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
    }
    
    func makeSortedSection() {
        let friendsDictionary = Dictionary.init(grouping: friendsResult ) { $0.lastName.prefix(1) }
        friendsWithSectionsResults = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendsWithSectionsResults.sort { $0.title < $1.title }
    }
    
        
}

extension FriendsPresenterImplementation {
    
    func getModelAtIndex(indexPath: IndexPath) -> UserRealm? {
        return friendsWithSectionsResults[indexPath.section].items[indexPath.row]
    }
    
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

struct Section<T> {
    var title: String
    var items: [T]
}


//Инициализировалось в FriendsTable View. дописать ... CoreData
//var presenterCD = UserListPresenterImplementation(database: UserCDRepository(stack: CoreDataStack.shared), api: VKApi())

//CoreData
protocol UserListPresenter {
    func getUserList(completion: @escaping (Swift.Result<[UserVK], Error>) -> ())
    func getUsersFromDatabase() -> [UserVK]
}
//CoreData
class UserListPresenterImplementation: UserListPresenter {
    let vkApi: VKApi
    let database: UserCDRepository
    
    init(database: UserCDRepository, api: VKApi) {
        self.vkApi = api
        self.database = database
    }
    
    func getUserList(completion: @escaping (Swift.Result<[UserVK], Error>) -> ()) {
        vkApi.getFriendList(token: Session.instance.token, version: Session.instance.version)
        { [weak self] result in
            switch result {
            case .success(let users):
                users.forEach{ self?.database.create(entity: $0) }
                completion(.success(users))
            case .failure(let error):
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
    }
    
    func getUsersFromDatabase() -> [UserVK] {
        return database.getAll()
    }
}
