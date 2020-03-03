//
//  ProfileTableViewCellModel.swift
//  VK
//
//  Created by Дмитрий Константинов on 03.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct ProfileCell {
    var statusMessage: String = ""
    var friendsCountButton: String = ""
    var subscribesCountButton: String = ""
    var currentCity: String = ""
    var placeOfWorkButton: String = ""
    var photoCollection: [URL] = []
    
    var statusStackViewIsEmpty: Bool = true
    var friendsStackViewIsEmpty: Bool = true
    var cityStackViewIsEmpty: Bool = true
    var workPlaceStackViewIsEmpty: Bool = true
    var photoCollectionIsEmpty: Bool = true
}
