//
//  Extension + FileEntity.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 21.08.2022.
//

import Foundation

extension FileEntity {
    func converted() -> FileItem? {
        guard let typeData = self.type,
              let type = try? JSONDecoder().decode(ItemType.self, from: typeData),
              let fileID = self.id,
              let fileName = self.fileName else {
                  return nil
              }
        var file = FileItem(fileType: type,
                            depthLevel: Int(self.depthLevel),
                            id: fileID,
                            ownerID: self.ownerID,
                            url: self.url,
                            fileName: fileName,
                            parentId: self.parentId)
        if let data = self.contentItems {
            file.contentItems = try? JSONDecoder().decode([FileItem]?.self, from: data)
        }
        return file
    }
}
