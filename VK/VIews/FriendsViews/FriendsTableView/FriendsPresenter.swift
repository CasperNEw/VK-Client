//
//  FriendsPresenter.swift
//  VK
//
//  Created by Дмитрий Константинов on 01.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

protocol FriendsPresenter {
    
   // func getUsers()
    func viewDidLoad()
    func searchFriends(name: String)
    
}

class FriendsPresenterImplementation: FriendsPresenter {
    
    
    
    
    private var vkApi: VKApi
    private var database: UserRepository
    //выносим все данные из ViewController'a в Presenter
    private var dataFriends = [UserVK]()
    private var friendsWithSections = [Section<UserVK>]()
    //var friendsSection = [Section<UserVK>]()
    
    init() {
        vkApi = VKApi()
        database = UserRepository()
    }
    
    func viewDidLoad() {
        getUsersFromDatabase()
        getUsersFromApi()
    }
    
    func searchFriends(name: String) {
        do {
            self.dataFriends = name.isEmpty ?
                Array(try database.getAllUsers()).map{ $0.toModel() } :
                Array(try database.searchusers(name: name)).map{ $0.toModel() }
            
            //В рамках текущей реализации сдесь должна быть проверка на то какую БД мы используем. То есть возможен сценарий когда dataFriends у нас != 0, но имеется проблема с БД Realm. И при инициализации страницы мы получили исходные данные из CoreData.
             
            let friendsDictionary = Dictionary(grouping : dataFriends) { $0.lastName.prefix(1) }
            
            friendsWithSections = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
            friendsWithSections.sort { $0.title < $1.title }
            
            //TODO ??
        } catch {
            print(error)
        }
    }

    private func getUsersFromDatabase() {
        do {
            self.dataFriends = Array(try database.getAllUsers()).map{ $0.toModel() }
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
        
        vkApi.getFriendList(token: Session.instance.token, version: Session.instance.version)
        { [weak self] result in
            switch result {
            case .success(let users):
                self?.dataFriends = users
                self?.database.addUsers(users: users)
                //TODO Upload DB data ?
            case .failure(let error):
                //TODO Alert to User in VC
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
        
    }
    
    func makeSortedSection() {
        let friendsDictionary = Dictionary.init(grouping: dataFriends ) { $0.lastName.prefix(1) }
        friendsWithSections = friendsDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendsWithSections.sort { $0.title < $1.title }
        //TODO ??
    }
    
        
}
