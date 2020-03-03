//
//  NewsTableViewCellModel.swift
//  VK
//
//  Created by Дмитрий Константинов on 03.03.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct NewsCell {
    var mainAuthorImage: String = ""
    var mainAuthorName: String = ""
    var publicationDate: String = ""
    var publicationText: String = ""
    var publicationLikeButtonStatus: Bool = false
    var publicationLikeButtonCount: Int = 0
    var publicationCommentButton: String = ""
    var publicationForwardButton: String = ""
    var publicationNumberOfViews: String = ""
    var photoCollection: [URL] = []

    var newsCollectionViewIsEmpty: Bool = true
}
