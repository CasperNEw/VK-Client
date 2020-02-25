//
//  UserProfilePresenter.swift
//  VK
//
//  Created by Дмитрий Константинов on 19.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation
import RealmSwift

protocol UserProfilePresenter {
    
    func loadData()
    func searchGroups(name: String)
    func deleteEntity(indexPath: IndexPath)
    
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    func getModelAtIndex(indexPath: IndexPath) -> GroupRealm?
}

class UserProfilePresenterImplementation: UserProfilePresenter {
    
    private var vkApi: VKApi
    private var database: GroupSourse
    private weak var view: GroupsTableViewUpdater?
    private var groupsResult: Results<GroupRealm>!
    private var token: NotificationToken?
    
    init(database: GroupSourse, view: GroupsTableViewUpdater) {
        vkApi = VKApi()
        self.database = database
        self.view = view
    }
    
    deinit {
        token?.invalidate()
    }
    
    func getUserData() {
        
//        if let id = user?.id {
//            vkApi.getPhotoInAlbum(token: Session.instance.token, version: Session.instance.version, ownerId: String(id), album: .profile) { [weak self] result in
//                do {
//                    let resultData = try result.get()
//                    self?.dataPhotos = resultData
//
//                    self?.tableView.reloadData()
//                } catch {
//                    print("[Logging] Error retrieving the value: \(error)")
//                }
//            }
//            vkApi.getUserSpecialInformation(token: Session.instance.token, userId: String(id)) { [weak self] result in
//                do {
//                    let resultData = try result.get()
//                    self?.dataUserSpecial = resultData
//                    self?.loadMainPhoto()
//                    self?.loadCellData()
//                    self?.tableView.reloadData()
//                } catch {
//                    print("[Logging] Error retrieving the value: \(error)")
//                }
//            }
//        } else { return }
        
    }
    
    func loadData() {
        getGroupsFromApi()
    }
    
    func searchGroups(name: String) {
        
        do {
            groupsResult = name.isEmpty ? try database.getAllGroups() : try database.searchGroup(name: name)
            tokenInitializaion()
        } catch {
            print(error)
        }
    }
    
    func deleteEntity(indexPath: IndexPath) {
        deleteFromDatabase(indexPath: indexPath)
        //deleteFromServer()
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
        vkApi.getGroupListForUser(token: Session.instance.token, version: Session.instance.version, user: Session.instance.userId) { result in
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
            groupsResult = try database.getAllGroups()
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

extension UserProfilePresenterImplementation {
    
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

