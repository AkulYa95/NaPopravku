//
//  GridView.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 15.08.2022.
//

import SwiftUI

struct GridView: View {
    @ObservedObject var viewModel: ListViewViewModel
    @FocusState var focusedItem: Focusable?

    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 100))
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: adaptiveColumns, spacing: 20) {
                ForEach($viewModel.items, id: \.id) { $item in
                    Group {
                        if item.fileType == .folder {
                            NavigationLink(destination: ContentView(viewModel: ContentViewViewModel(currentUser: viewModel.user,
                                                                                                    parentFolder: item))) {
                                VStack {
                                    Image(systemName: "folder")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 50, maxHeight: 50)
                                    TextField(item.fileName, text: $item.fileName)
                                        .multilineTextAlignment(.center)
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
                                
                            }.buttonStyle(PlainButtonStyle())
                        } else {
                            VStack {
                                Image(systemName: "doc")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 50, maxHeight: 50)
                                TextField(item.fileName, text: $item.fileName)
                                    .multilineTextAlignment(.center)
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
                        Button(role: .destructive) {
                            viewModel.delete(item)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
