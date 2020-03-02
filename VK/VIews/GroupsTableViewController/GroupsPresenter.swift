//
//  GroupsPresenter.swift
//  VK
//
//  Created by Дмитрий Константинов on 15.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation
import RealmSwift

protocol GroupsPresenter {
    
    func viewDidLoad()
    func filterContent(searchText: String)
    func deleteEntity(indexPath: IndexPath)
    func sendToNextVC(indexPath: IndexPath) -> Int
    
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    func getModelAtIndex(indexPath: IndexPath) -> GroupRealm?
}

class GroupsPresenterImplementation: GroupsPresenter {
    
    private var vkApi: VKApi
    private var database: GroupSourse
    private weak var view: GroupsTableViewControllerUpdater?
    private var groupsResult: Results<GroupRealm>!
    private var token: NotificationToken?
    
    init(database: GroupSourse, view: GroupsTableViewControllerUpdater) {
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
    
    func filterContent(searchText: String) {
        
        do {
            groupsResult = searchText.isEmpty ? try database.getAllGroups() : try database.searchGroups(name: searchText)
            tokenInitializaion()
        } catch {
            print(error)
        }
    }
    
    func sendToNextVC(indexPath: IndexPath) -> Int {
        return -groupsResult[indexPath.row].id
    }
    
    func deleteEntity(indexPath: IndexPath) {
        deleteFromDatabase(indexPath: indexPath)
        //TODO: deleteFromServer()
    }
    
    private func deleteFromDatabase(indexPath: IndexPath) {
        guard let targetForDelete = groupsResult?[indexPath.row] else { return }
        do {
            let name = targetForDelete.name
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(targetForDelete)
            try realm.commitWrite()
            print("[Logging] delete group from favorite - \(name)")
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
                self.view?.endRefreshing()
                self.view?.showConnectionAlert()
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
    }
    
    private func getGroupsFromDatabase() {
        do {
            groupsResult = try database.getAllGroups()
            view?.endRefreshing()
            tokenInitializaion()
        } catch {
            view?.endRefreshing()
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

extension GroupsPresenterImplementation {
    
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

