//
//  TabbarForm.swift
//  VK
//
//  Created by Дмитрий Константинов on 28.11.2019.
//  Copyright © 2019 Дмитрий Константинов. All rights reserved.
//

import UIKit

class TabbarForm: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class ProfileForm: UITabBarController {
    
    
    
    
    
    var username = ""
    //реализация метода получения данных с предыдущего View
    override func viewDidLoad() {
        print("[Logging] connect with username - \(username)")
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

class TableViewFriends: UITableView {
    
    var username = ""
    //реализация метода получения данных с предыдущего View
    override func viewDidLoad() {
        print("[Logging] connect with username - \(username)")
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
