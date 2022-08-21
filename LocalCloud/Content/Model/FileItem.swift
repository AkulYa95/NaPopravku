//
//  FileItem.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 14.08.2022.
//

import Foundation

enum ItemType: Codable {
    case file
    case folder
}

struct FileItem: Identifiable, Codable {
    let id: UUID
    let fileType: ItemType
    let ownerID: String?
    let depthLevel: Int
    let url: URL?
    var fileName: String
    var contentItems: [FileItem]?
    var parentId: UUID?
    
    init(fileType: ItemType, depthLevel: Int, id: UUID, ownerID: String?, url: URL?, fileName: String, parentId: UUID?) {
        self.id = id
        self.depthLevel = depthLevel
        self.fileType = fileType
        self.ownerID = ownerID
        self.url = url
        self.fileName = fileName
        self.parentId = parentId
        switch fileType {
        case .folder:
            contentItems = []
        case .file:
            contentItems = nil
        }
    }
}
