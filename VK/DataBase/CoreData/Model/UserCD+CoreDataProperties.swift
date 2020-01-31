//
//  UserCD+CoreDataProperties.swift
//  
//
//  Created by Дмитрий Константинов on 30.01.2020.
//
//

import Foundation
import CoreData


extension UserCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCD> {
        return NSFetchRequest<UserCD>(entityName: "UserCD")
    }

    @NSManaged public var id: Int64
    @NSManaged public var firstName: String
    @NSManaged public var lastName: String
    @NSManaged public var isClosed: Bool //Bool?
    @NSManaged public var canAccessClosed: Bool //Bool?
    @NSManaged public var photo100: String
    @NSManaged public var online: Int16
    @NSManaged public var deactivated: String?

}

//Проблема, в Objective-C нет типа Bool?. В настройках сущности CoreData выставил дефолтные значения для isClossed (false) и canAccessClosed (true). При тесте проблем выявлено не было.

extension UserCD {
    func toCommonItem() -> UserVK {
        return UserVK(id: Int(self.id), firstName: self.firstName, lastName: self.lastName, isClosed: self.isClosed, canAccessClosed: self.canAccessClosed, photo100: self.photo100, online: Int(self.online), deactivated: self.deactivated ?? "")
    }
}
