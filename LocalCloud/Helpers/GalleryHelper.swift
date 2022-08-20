//
//  GalleryHelper.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 16.08.2022.
//

import Foundation
import Photos

class GalleryHelper {
    
    static func getRequestForImagePicker(completion access: @escaping (Bool) -> Void) {
        let accessStatus = PHPhotoLibrary.authorizationStatus()
        switch accessStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ status in
                if status == .authorized {
                    access(true)
                    return
                }
            })
        case .restricted, .denied:
            access(false)
        case .authorized:
            access(true)
        default:
            access(false)
        }
    }
}
