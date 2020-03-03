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
    func getModelAtIndex(indexPath: IndexPath) -> GroupsCell?
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

    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return groupsResult?.count ?? 0
    }
}

extension GroupsPresenterImplementation {
    
    
    func getModelAtIndex(indexPath: IndexPath) -> GroupsCell? {
        return renderGroupRealmToGroupsCell(group: groupsResult?[indexPath.row])
    }
    
    private func renderGroupRealmToGroupsCell(group: GroupRealm?) -> GroupsCell? {
        guard let group = group else { return nil }
        var cellModel = GroupsCell()
        
        cellModel.groupImage = group.photo100
        cellModel.groupsName = group.name
        cellModel.groupsActivity = group.activity
        cellModel.groupsMembersCount = prepareCount(modelCount: group.membersCount)
        cellModel.groupsActivityIsHidden = group.activity.isEmpty
        cellModel.groupsMembersCountIsHidden = group.membersCount == 0 ? true : false
        
        return cellModel
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

