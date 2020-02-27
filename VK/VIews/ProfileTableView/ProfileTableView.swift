//
//  ProfileTableView.swift
//  VK
//
//  Created by Дмитрий Константинов on 11.12.2019.
//  Copyright © 2019 Дмитрий Константинов. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProfileTableViewUpdater: AnyObject {
    func showConnectionAlert()
    func showIncorrectDataAlert()
    func reloadTable()
    func updateTable(forDel: [Int], forIns: [Int], forMod: [Int])
    func setupProfileImage(name: String, date: String, url: URL, processor: CroppingImageProcessor)
}

class ProfileTableView: UITableViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileDate: UILabel!
    
    var presenter: ProfilePresenter?
    var customRefreshControl = UIRefreshControl()
    
    var fromVC: Int?

    override func viewDidLoad() {
        presenter = ProfilePresenterImplementation(database: ProfileRepository(), view: self)
        addRefreshControl()
        setupTableForSmoothScroll()
        print("[Logging] load Profile View")
        
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        //tableView.register(UINib(nibName: "UserProfileNewsCell", bundle: nil), forCellReuseIdentifier: "UserProfileNews")
        
        //автоматическое изменение высоты ячейки
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.viewDidLoad(fromVC: fromVC)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRowsInSection(section: section) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell, let model = presenter?.getModelAtIndex(indexPath: indexPath) else { return UITableViewCell() }
        
        cell.renderCell(model: model)
        return cell
    }
    
    func addRefreshControl() {
        customRefreshControl.attributedTitle = NSAttributedString(string: "Refreshing ...")
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
    }
    
    @objc func refreshTable() {
        print("[Logging] Update Realm[ProfileRealm] from server")
        
        presenter?.viewDidLoad(fromVC: fromVC)
        self.customRefreshControl.endRefreshing()
    }
    
    func setupTableForSmoothScroll() {
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
    }
}

extension ProfileTableView {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        if deltaOffset < 1000.0 {
            //presenter?.uploadData()
            print("[Logging] TODO: upload data")
        }
    }
}

extension ProfileTableView: ProfileTableViewUpdater {
    
    func updateTable(forDel: [Int], forIns: [Int], forMod: [Int]) {
        
        tableView.beginUpdates()
        tableView.deleteRows(at: forDel.map { IndexPath(row: $0, section: 0) }, with: .none)
        tableView.insertRows(at: forIns.map { IndexPath(row: $0, section: 0) }, with: .none)
        tableView.reloadRows(at: forMod.map { IndexPath(row: $0, section: 0) }, with: .none)
        tableView.endUpdates()
        
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func showConnectionAlert() {
        let alert = UIAlertController(title: "Error", message: "There was an error loading your data, check your network connection", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showIncorrectDataAlert() {
        let alert = UIAlertController(title: "Error", message: "An error occurred while loading data", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupProfileImage(name: String, date: String, url: URL, processor: CroppingImageProcessor) {
        
        profileName.text = name
        profileDate.text = date
        profileImage.contentMode = .scaleAspectFill
        profileImage.kf.setImage(with: url, options: [.processor(processor)])
    }
}
