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
    
    func delete(_ item: FileItem, ownerID: String) {
        guard let rootEntity = fetchRootFolder(withOwnerID: ownerID),
              let entityContentData = rootEntity.contentItems,
              var entityItems = try? JSONDecoder().decode([FileItem]?.self, from: entityContentData) else {
                  return
              }
        if let index = entityItems.firstIndex(where: { $0.id == item.id }) {
            entityItems.remove(at: index)
            let newItemsData = try? JSONEncoder().encode(entityItems)
            rootEntity.contentItems = newItemsData
            save()
            return
        }
        if let index = entityItems.firstIndex(where: { $0.id == item.parentId }),
           let finalIndex = entityItems[index].contentItems?.firstIndex(where: { $0.id == item.id }) {
            entityItems[index].contentItems?.remove(at: finalIndex)
            let newItemsData = try? JSONEncoder().encode(entityItems)
            rootEntity.contentItems = newItemsData
            save()
            return
        }
    }
    
    func saveNewFile(_ item: FileItem, ownerID: String) {
        guard let rootEntity = fetchRootFolder(withOwnerID: ownerID),
              let entityContentData = rootEntity.contentItems,
              var entityItems = try? JSONDecoder().decode([FileItem]?.self, from: entityContentData) else {
                  return
              }
        if rootEntity.id == item.parentId {
            entityItems.insert(item, at: 0)
            let newItemsData = try? JSONEncoder().encode(entityItems)
            rootEntity.contentItems = newItemsData
            save()
            return
        }
        if let index = entityItems.firstIndex(where: { $0.id == item.parentId }) {
            entityItems[index].contentItems?.insert(item, at: 0)
            let newItemsData = try? JSONEncoder().encode(entityItems)
            rootEntity.contentItems = newItemsData
            save()
            return
        }
    }
    
    func fetchContentItemsFrom(withOwnerID ownerID: String, depthLevel: Int, id: UUID) -> FileItem? {
        let rootFolder = fetchRootFolder(withOwnerID: ownerID)?.converted()
        let folder = goInto(array: rootFolder?.contentItems, times: depthLevel)?.first(where: { $0.id == id })
        return folder
    }
    
    private func goInto(array: [FileItem]?, times: Int) -> [FileItem]? {
        guard times != 0 else { return nil }
        if times == 1 {
            return array
        } else {
            guard let newArray = array?[0].contentItems else { return array }
            let newTimes = times - 1
            return goInto(array: newArray, times: newTimes)
        }
    }
    
    func renameItem(_ item: FileItem, withOwnerID ownerID: String) {
        guard let rootEntity = fetchRootFolder(withOwnerID: ownerID),
              let entityContentData = rootEntity.contentItems,
              var entityItems = try? JSONDecoder().decode([FileItem]?.self, from: entityContentData) else {
                  return
              }
        if let index = entityItems.firstIndex(where: { $0.id == item.id }) {
            entityItems[index].fileName = item.fileName
            let newItemsData = try? JSONEncoder().encode(entityItems)
            rootEntity.contentItems = newItemsData
            save()
            return
        }
        if let index = entityItems.firstIndex(where: { $0.id == item.parentId }),
           let finalIndex = entityItems[index].contentItems?.firstIndex(where: { $0.id == item.id }) {
            entityItems[index].contentItems?[finalIndex].fileName = item.fileName
            let newItemsData = try? JSONEncoder().encode(entityItems)
            rootEntity.contentItems = newItemsData
            save()
            return
        }
    }
    
    func fetchRootFolder(withOwnerID ownerID: String) -> FileEntity? {
        let request: NSFetchRequest<FileEntity> = FileEntity.fetchRequest()
        do {
            let folder = try viewContext.fetch(request).first(where: { $0.ownerID == ownerID })
            return folder
        } catch {
            return nil
        }
    }
    
    func fetchAllFiles(withID id: String) -> [FileItem] {
        let request: NSFetchRequest<FileEntity> = FileEntity.fetchRequest()
        do {
            let file = try viewContext.fetch(request).first(where: { $0.ownerID == id })
            guard let contentItems = file?.contentItems,
                  let items = try JSONDecoder().decode([FileItem]?.self, from: contentItems)  else {
                      return []
                  }
            return items
        } catch {
            return []
        }
    }
}
