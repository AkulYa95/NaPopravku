//
//  ListViewViewModel.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 15.08.2022.
//

import Foundation

class ListViewViewModel:ObservableObject {
    @Published var items: [FileItem]
    
    func delete(_ item: FileItem) {
        items.removeAll(where: { $0.id == item.id })
    }
    
    init(items: [FileItem]) {
        self.items = items
    }
}
