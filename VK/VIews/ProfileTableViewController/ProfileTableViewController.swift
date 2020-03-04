//
//  ProfileTableViewController.swift
//  VK
//
//  Created by Дмитрий Константинов on 11.12.2019.
//  Copyright © 2019 Дмитрий Константинов. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProfileTableViewControllerUpdater: AnyObject {
    func showConnectionAlert()
    func reloadTable()
    func endRefreshing()
    func setupProfileImage(name: String, date: String, url: URL, processor: CroppingImageProcessor)
}

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileDate: UILabel!
    
    private var presenter: ProfilePresenter?
    private var customRefreshControl = UIRefreshControl()
    
    var fromVC: Int?

    override func viewDidLoad() {
        presenter = ProfilePresenterImplementation(view: self)
        addRefreshControl()
        updateNavigationItem()
        setupTableForSmoothScroll()
        print("[Logging] load Profile View")
        
        tableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsTableViewCell")
        
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
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell, let profileModel = presenter?.getModel() else { return UITableViewCell() }
            
            cell.renderCell(model: profileModel)
            return cell
        }
        if indexPath.row > 0 {
            guard let newsCell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as? NewsTableViewCell, let newsModel = presenter?.getModelAtIndex(indexPath: indexPath) else { return UITableViewCell() }
            
            newsCell.renderCell(model: newsModel)
            return newsCell
        }
        return UITableViewCell()
    }
    
    private func addRefreshControl() {
        customRefreshControl.attributedTitle = NSAttributedString(string: "Refreshing ...")
        customRefreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(customRefreshControl)
    }
    
    @objc private func refreshTable() {
        print("[Logging] Update Realm[ProfileRealm] from server")
        
        presenter?.viewDidLoad(fromVC: fromVC)
    }
    
    private func updateNavigationItem() {
        navigationController?.navigationBar.tintColor = .darkGray
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func setupTableForSmoothScroll() {
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
    }
}

extension ProfileTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        if deltaOffset < 800.0 {
            presenter?.uploadData(fromVC: fromVC)
        }
    }
}

extension ProfileTableViewController: ProfileTableViewControllerUpdater {
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func endRefreshing() {
        self.customRefreshControl.endRefreshing()
    }
    
    func showConnectionAlert() {
        let alert = UIAlertController(title: "Error", message: "There was an error loading your data, check your network connection", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupProfileImage(name: String, date: String, url: URL, processor: CroppingImageProcessor) {
        
        profileName.text = name
        profileDate.text = date
        profileImage.contentMode = .scaleAspectFill
        profileImage.kf.setImage(with: url, options: [.processor(processor)])
        
        profileName.textColor = .white
        profileDate.textColor = .white
    }
}
