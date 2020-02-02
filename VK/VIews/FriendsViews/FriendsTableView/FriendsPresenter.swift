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
    
   // func getUsers()
    func viewDidLoad()
    func searchFriends(name: String)
    
}

class FriendsPresenterImplementation: FriendsPresenter {
    
    
    
    
    private var vkApi: VKApi
    private var database: UserSourse
    //выносим все данные из ViewController'a в Presenter
//    private var dataFriends = [UserVK]()
//    private var friendsWithSections = [Section<UserVK>]()
    //var friendsSection = [Section<UserVK>]()
    private var friendsResult: Results<UserRealm>!
    private var friendsWithSectionsResults = [Section<UserRealm>]()
    
    init(database: UserSourse) {
        vkApi = VKApi()
        self.database = database
    }
    
    func viewDidLoad() {
        getUsersFromDatabase()
        getUsersFromApi()
    }
    
    func searchFriends(name: String) {
      /*  do {
            self.dataFriends = name.isEmpty ?
                Array(try database.getAllUsers()).map{ $0.toModel() } :
                Array(try database.searchUsers(name: name)).map{ $0.toModel() }
            
            //В рамках текущей реализации сдесь должна быть проверка на то какую БД мы используем. То есть возможен сценарий когда dataFriends у нас != 0, но имеется проблема с БД Realm. И при инициализации страницы мы получили исходные данные из CoreData.
             
            let friendsDictionary = Dictionary(grouping : dataFriends) { $0.lastName.prefix(1) }
            
            friendsWithSections = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
            friendsWithSections.sort { $0.title < $1.title }
            
            //TODO ??
        } catch {
            print(error)
        }*/
    }

    private func getUsersFromDatabase() {
        do {
            self.friendsResult = try database.getAllUsers()
            self.makeSortedSection()
        } catch {
            print(error)
        }
        
        /* //or use CoreData database ...
        self.dataFriends = presenterCD.getUsersFromDatabase()
        self.makeSortedSection()
        */
    }
    
    private func getUsersFromApi() {
        
        vkApi.getFriendList(token: Session.instance.token, version: Session.instance.version) { result in
            switch result {
            case .success(let users):
                do {
                    self.database.addUsers(users: users)
                    self.friendsResult = try self.database.getAllUsers()
                    self.makeSortedSection()
                } catch {
                    print(error)
                }
            case .failure(let error):
                //TODO Alert to User in VC
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
        
    }
    
    func makeSortedSection() {
        let friendsDictionary = Dictionary.init(grouping: friendsResult ) { $0.lastName.prefix(1) }
        friendsWithSectionsResults = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendsWithSectionsResults.sort { $0.title < $1.title }
        //TODO ??
//        let friendsDictionary = Dictionary.init(grouping: dataFriends ) { $0.lastName.prefix(1) }
//        friendsWithSections = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
//        friendsWithSections.sort { $0.title < $1.title }
    }
    
        
}
