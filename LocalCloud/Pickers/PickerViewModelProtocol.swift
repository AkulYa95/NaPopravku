//
//  PickerViewModelProtocol.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 21.08.2022.
//

import Foundation

protocol PickerViewModelProtocol {
    func validateFileSize(_ url: URL) -> Bool
    func validateFileExtension(_ url: URL) -> Bool
}

extension PickerViewModelProtocol {
    func validateFileSize(_ url: URL) -> Bool {
        let limit = 20 * 1024 * 1024
        let isValidate = url.fileSize >= limit ? false : true
        return isValidate
    }
    
    func validateFileExtension(_ url: URL) -> Bool {
        var forbiddenExtensions = ["txt", "livephoto"]
        return url.pathExtension == "txt" ? false : true
    }
}
