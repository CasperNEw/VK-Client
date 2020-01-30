//
//  CoreDataStack.swift
//  VK
//
//  Created by Дмитрий Константинов on 30.01.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private let storeContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        storeContainer = NSPersistentContainer(name: "VK")
        storeContainer.loadPersistentStores { (_, error) in }
        context = storeContainer.viewContext
    }
}
