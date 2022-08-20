//
//  DocumentPickerViewModel.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 14.08.2022.
//

import Foundation
import UniformTypeIdentifiers

class DocumentPickerViewModel: ObservableObject {
    let types: [UTType] = [
        UTType.png,
        UTType.message,
        UTType.aiff,
        UTType.aliasFile,
        UTType.appleArchive,
        UTType.archive,
        UTType.audio,
        UTType.item,
        UTType.jpeg,
        UTType.pdf,
        UTType.gif,
        UTType.mp3,
        UTType.movie,
        UTType.archive,
        UTType.xml
    ]
}
