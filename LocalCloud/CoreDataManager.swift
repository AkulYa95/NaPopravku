//
//  CoreDataManager.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 14.08.2022.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "ItemsAppModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func save(completion: @escaping (Error?) -> Void = { _ in }) {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func delete(_ object: FileEntity, completion: @escaping (Error?) -> Void = { _ in }) {
        viewContext.delete(object)
        save(completion: completion)
    }
    
    func getAllFiles(withID id: String) -> [FileEntity] {
        let request: NSFetchRequest<FileEntity> = FileEntity.fetchRequest()
        do {
            let files = try viewContext.fetch(request).filter({ $0.ownerID == id })
            return files
        } catch {
            return []
        }
    }
}
