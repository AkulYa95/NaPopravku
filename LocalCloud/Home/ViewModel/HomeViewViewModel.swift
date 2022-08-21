//
//  HomeViewViewModel.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 17.08.2022.
//

import Foundation

class HomeViewViewModel: ObservableObject {
    
    @Published var user: UserInfo
    @Published var rootFolder: FileItem?
    @Published var segmentedIndex: Int = UserDefaults.standard.integer(forKey: DefaultKeys.segmentedIndex)
    
    func fetchUser() {
        user.getToken { error in
            guard error == nil else { return }
            self.getRootFolder()
        }
    }
    
    private func getRootFolder() {
        guard let id = user.userID else { return }
        guard let folder = CoreDataManager.shared.fetchRootFolder(withOwnerID: id)?.converted() else {
            rootFolder = createdRootFolder(withOwnerID: id)
            return
        }
        rootFolder = folder
    }
    
    private func createdRootFolder(withOwnerID id: String) -> FileItem {
        let entity = FileEntity(context: CoreDataManager.shared.viewContext)
        let folder = FileItem(fileType: .folder,
                              depthLevel: 0,
                              id: UUID(),
                              ownerID: id,
                              url: nil,
                              fileName: "Documents",
                              parentId: nil)
        entity.type = try? JSONEncoder().encode(folder.fileType)
        entity.depthLevel = Int16(folder.depthLevel)
        entity.id = folder.id
        entity.ownerID = folder.ownerID
        entity.url = folder.url
        entity.fileName = folder.fileName
        entity.contentItems = try? JSONEncoder().encode(folder.contentItems)
        entity.parentId = folder.parentId
        CoreDataManager.shared.save()
        return folder
    }

    init(user: UserInfo) {
        self.user = user
    }
}
