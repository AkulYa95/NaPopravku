//
//  ListView.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 15.08.2022.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: ListViewViewModel
    let image = Image(systemName: "folder")
    func deleteIlem(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = viewModel.items[index]
            viewModel.delete(item)
        }
    }
    var body: some View {
        List {
            ForEach(viewModel.items, id: \.id) { item in
                HStack {
                    Image(systemName: "folder")
                    Text(item.fileName ?? "error")
                }
            }
            .onDelete(perform: deleteIlem)
        }
        .listStyle(.inset)
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(viewModel: ListViewViewModel(items: []))
    }
}
