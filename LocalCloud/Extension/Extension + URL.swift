//
//  Extension + URL.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 16.08.2022.
//

import Foundation

extension URL {
    var attributes: [FileAttributeKey: Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        print(attributes)
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
}
