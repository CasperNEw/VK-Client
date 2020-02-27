//
//  GlobalGroupsPresenter.swift
//  VK
//
//  Created by Дмитрий Константинов on 27.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation
import RealmSwift

protocol GlobalGroupsPresenter {
    
    func viewDidLoad()
    func searchGroupsFromApi(name: String)
    func uploadFromApi(name: String)
    
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    func getModelAtIndex(indexPath: IndexPath) -> GroupRealm?
}

class GlobalGroupsPresenterImplementation: GlobalGroupsPresenter {
    
    private var vkApi: VKApi
    private var database: GlobalGroupSourse
    private weak var view: GlobalGroupsTableViewUpdater?
    private var groupsResult: Results<GroupRealm>!
    //private var groupsSearchResult: Results<GroupRealm>!
    private var token: NotificationToken?
    
    private var offset = 0
    private var status = false
    private var searchName = ""
    
    init(database: GlobalGroupSourse, view: GlobalGroupsTableViewUpdater) {
        vkApi = VKApi()
        self.database = database
        self.view = view
    }
    
    deinit {
        token?.invalidate()
    }
    
    func viewDidLoad() {
        getGroupsFromApi()
    }
    
    func uploadFromApi(name: String) {
        if status {
            status = false
            searchGroupsFromApi(name: name)
        }
    }
    
    func searchGroupsFromApi(name: String) {
        
        if self.searchName != name {
            self.searchName = name
            self.offset = 0
        }
        
        do {
            if name == "" {
                groupsResult = try database.getUserGroups()
                offset = 0
                tokenInitializaion()
                return
            }
            
            vkApi.getSearchGroup(token: Session.instance.token, version: Session.instance.version, offset: offset, text: name) { result in
                switch result {
                case .success(let groups):
                    self.database.addGroups(groups: groups)
                    self.getSortedGroupsFromDatabase(name: name)
                    self.offset += 20
                    self.status = true
                case .failure(let error):
                    self.view?.showConnectionAlert()
                    print("[Logging] Error retrieving the value: \(error)")
                }
            }
            tokenInitializaion()
        } catch {
            print(error)
        }
    }
    
    
    
    private func getGroupsFromApi() {
        vkApi.getGroupList(token: Session.instance.token, version: Session.instance.version, user: Session.instance.userId) { result in
            switch result {
            case .success(let groups):
                self.database.addGroups(groups: groups)
                self.getGroupsFromDatabase()
            case .failure(let error):
                self.view?.showConnectionAlert()
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
    }
    
    private func getGroupsFromDatabase() {
        do {
            groupsResult = try database.getUserGroups()
            tokenInitializaion()
        } catch {
            print(error)
        }
    }
    
    private func getSortedGroupsFromDatabase(name: String) {
        do {
            groupsResult = try database.searchGroups(name: name)
            tokenInitializaion()
        } catch {
            print(error)
        }
    }
    
    private func tokenInitializaion() {
        
        token = groupsResult?.observe { [weak self] results in
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
    
}

extension GlobalGroupsPresenterImplementation {
    
    func getModelAtIndex(indexPath: IndexPath) -> GroupRealm? {
        return groupsResult?[indexPath.row]
    }
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return groupsResult?.count ?? 0
    }
}

