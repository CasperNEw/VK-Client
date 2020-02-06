//
//  UserRepository.swift
//  VK
//
//  Created by Дмитрий Константинов on 30.01.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import CoreData

protocol Repository {
    
    associatedtype Entity
    
    func getAll() -> [Entity]
    func get(id: Int) -> Entity?
    func update(entity: Entity) -> Bool
    func create(entity: Entity) -> Bool
    func delete(entity: Entity) -> Bool
}

class UserCDRepository: Repository {
    
    typealias Entity = UserVK
    
    let context: NSManagedObjectContext
    
    init(stack: CoreDataStack) {
        self.context = stack.context
    }
    
    private func query(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]? = nil) -> [UserVK] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCD")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let objects = try context.fetch(fetchRequest) as? [UserCD]
            return objects?.map{ $0.toCommonItem() } ?? []
        } catch {
            return []
        }
    }
    
    private func queryCD(with predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]? = nil) -> [UserCD] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserCD")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            return try (context.fetch(fetchRequest) as? [UserCD] ?? [])
        } catch {
            return []
        }
    }
    
    func getAll() -> [UserVK] {
        return query(with: nil, sortDescriptors: [NSSortDescriptor(key: "lastName", ascending: true)])
    }
    
    func get(id: Int) -> UserVK? {
        return query(with: NSPredicate(format: "id = %@", "\(id)")).first
    }
    
    func update(entity: UserVK) -> Bool {
        guard let entityToUpdate = queryCD(with: NSPredicate(format: "id = %@", "\(entity.id)")).first else {
            return false
        }
        
        if entityToUpdate.firstName != entity.firstName {
            entityToUpdate.setValue(entity.firstName, forKey: "firstName")
        }
        if entityToUpdate.lastName != entity.lastName {
            entityToUpdate.setValue(entity.lastName, forKey: "lastName")
        }
        if entityToUpdate.isClosed != entity.isClosed {
            entityToUpdate.setValue(entity.isClosed, forKey: "isClosed")
        }
        if entityToUpdate.canAccessClosed != entity.canAccessClosed {
            entityToUpdate.setValue(entity.canAccessClosed, forKey: "canAccessClosed")
        }
        if entityToUpdate.photo100 != entity.photo100 {
            entityToUpdate.setValue(entity.photo100, forKey: "photo100")
        }
        if entityToUpdate.online != entity.online {
            entityToUpdate.setValue(entity.online, forKey: "online")
        }
        if entityToUpdate.deactivated != entity.deactivated {
            entityToUpdate.setValue(entity.deactivated, forKey: "deactivated")
        }
        
        return save()
    }
    
    @discardableResult func create(entity: UserVK) -> Bool {
        
        if get(id: entity.id) != nil {
            return update(entity: entity)
        }
        //добавить проверку на существование в БД данной сущности
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "UserCD", in: context) else {
            return false
        }
        
        let userEntity = NSManagedObject(entity: entityDescription, insertInto: context)
        userEntity.setValue(entity.id, forKey: "id")
        userEntity.setValue(entity.firstName, forKey: "firstName")
        userEntity.setValue(entity.lastName, forKey: "lastName")
        userEntity.setValue(entity.isClosed, forKey: "isClosed")
        userEntity.setValue(entity.canAccessClosed, forKey: "canAccessClosed")
        userEntity.setValue(entity.photo100, forKey: "photo100")
        userEntity.setValue(entity.online, forKey: "online")
        userEntity.setValue(entity.deactivated, forKey: "deactivated")
        
        return save()
    }
    
    func delete(entity: UserVK) -> Bool {
        
        guard let objectToDelete = queryCD(with: NSPredicate(format: "id = %@", "\(entity.id)")).first else {
            return false
        }
        context.delete(objectToDelete)
        return true
    }
    
    private func save() -> Bool {
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    
    
    
    
}
