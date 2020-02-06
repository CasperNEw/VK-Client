//
//  FriendsConfigurator.swift
//  VK
//
//  Created by Дмитрий Константинов on 01.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

protocol FriendsConfigurator {
    func configure(view: FriendsTableView)
}

class FriendsConfiguratorImplementation: FriendsConfigurator {
    func configure(view: FriendsTableView) {
        //view.presenter = FriendsPresenterImplementation(database: UserRepository(), view: self)
        /*
         При переходе через код надо добавить при инициализации vc:
         vc.configurator = FriendsConfiguratorImplementation()
         */
    }
}
