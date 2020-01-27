//
//  CommonResponse.swift
//  VK
//
//  Created by Дмитрий Константинов on 27.01.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation

struct CommonResponse<T: Decodable>: Decodable {
    var response: ResponseData<T>
}

struct ResponseData<T: Decodable>: Decodable {
    var count: Int
    var items: [T]
}
