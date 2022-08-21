//
//  ListViewViewModel.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 15.08.2022.
//

import Foundation

class ListViewViewModel: ObservableObject {
    @Published var parentFolder: FileItem?
    @Published var items: [FileItem] = []
    @Published var editableItem: Editable = .none
    @Published var segmentedIndex: Int
    var user: UserInfo
    
    func delete(_ item: FileItem) {
        guard let ownerID = user.userID else { return }
        parentFolder?.contentItems?.removeAll(where: { $0.id == item.id })
        items.removeAll(where: { $0.id == item.id })
        CoreDataManager.shared.delete(item, ownerID: ownerID)

    }
    
    func rename(_ item: FileItem) {
        guard let ownerID = user.userID else { return }
        CoreDataManager.shared.renameItem(item, withOwnerID: ownerID)
    }
    
    init(parentFolder: FileItem?, user: UserInfo, segmentedIndex: Int) {
        self.user = user
        self.segmentedIndex = segmentedIndex
        guard let parentFolder = parentFolder,
              let items = parentFolder.contentItems else {
            return
        }
        self.items = items
    }
}
