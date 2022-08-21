//
//  ListView.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 15.08.2022.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var viewModel: ListViewViewModel
    @FocusState var focusedItem: Focusable?
    
    private func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = viewModel.items[index]
            viewModel.delete(item)
        }
    }
    var body: some View {
        List {
            ForEach($viewModel.items, id: \.id) { $item in
                Group {
                    if item.fileType == .folder {
                        NavigationLink(destination: ContentView(viewModel: ContentViewViewModel(currentUser: viewModel.user,
                                                                                                parentFolder: item))) {
                            HStack {
                                Image(systemName: "folder")
                                TextField(item.fileName, text: $item.fileName)
                                    .truncationMode(.middle)
                                    .focused($focusedItem, equals: .item(id: item.id.uuidString))
                                    .disabled(!(viewModel.editableItem == .item(id: item.id.uuidString)))
                                    .submitLabel(.done)
                                    .onSubmit {
                                        print("commit")
                                        viewModel.rename(item)
                                        viewModel.editableItem = .none
                                        focusedItem = Focusable.none
                                    }
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "doc")
                            TextField(item.fileName, text: $item.fileName)
                                .truncationMode(.middle)
                                .focused($focusedItem, equals: .item(id: item.id.uuidString))
                                .disabled(!(viewModel.editableItem == .item(id: item.id.uuidString)))
                                .submitLabel(.done)
                                .onSubmit {
                                    print("commit")
                                    viewModel.rename(item)
                                    viewModel.editableItem = .none
                                    focusedItem = Focusable.none
                                }
                        }
                    }
                }
                .contextMenu {
                    Button {
                        viewModel.editableItem = .item(id: item.id.uuidString)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.focusedItem = .item(id: item.id.uuidString)
                        }
                    } label: {
                        Label("Rename", systemImage: "pencil")
                    }
                }
            }
            .onDelete(perform: deleteItem)
        }
        .listStyle(.inset)
    }
}
