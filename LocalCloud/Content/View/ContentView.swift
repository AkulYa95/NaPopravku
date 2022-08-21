//
//  ContentView.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 13.08.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ContentViewViewModel
    var body: some View {
        VStack {
            if viewModel.segmentedIndex == 0 {
                ListView(viewModel: ListViewViewModel(parentFolder: viewModel.parentFolder,
                                                      user: viewModel.currentUser,
                                                      segmentedIndex: viewModel.segmentedIndex))
            } else {
                GridView()
            }
        }
        .onAppear(perform: {
            viewModel.getAllFiles()
        })
        .navigationTitle(viewModel.folderName)
        .sheet(isPresented: $viewModel.showImagePicker, content: {
            ImagePicker(viewModel: ImagePickerViewModel(),
                        imageURL: $viewModel.newFileURL,
                        alertMessage: $viewModel.alertMessage,
                        showAlert: $viewModel.isNeedAlert)
        })
        .sheet(isPresented: $viewModel.showDocumentPicker, content: {
            DocumentPicker(viewModel: DocumentPickerViewModel(),
                           documentURL: $viewModel.newFileURL,
                           alertMessage: $viewModel.alertMessage,
                           showAlert: $viewModel.isNeedAlert)
        })
        .alert(isPresented: $viewModel.isNeedAlert, content: {
            Alert(title: Text(viewModel.alertMessage),
                  dismissButton: .default(Text("OK")))
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Text(viewModel.userEmail)
                    Menu {
                        Section {
                            Picker(selection: $viewModel.segmentedIndex, label: Text("ShownType")) {
                                Label("List", systemImage: "list.dash").tag(0)
                                Label("Grid", systemImage: "square.grid.2x2").tag(1)
                            }
                        }
                        Section {
                            if viewModel.isAllowAddFolder {
                                Button {
                                    viewModel.addFolder()
                                } label: {
                                    Label("Add folder", systemImage: "folder.badge.plus")
                                }
                            }
                            Button {
                                viewModel.openImagePicker()
                            } label: {
                                Label("Add image", systemImage: "photo.on.rectangle")
                            }
                            Button {
                                viewModel.openDocumentPicker()
                            } label: {
                                Label("Add document", systemImage: "doc.on.doc")
                            }
                        }
                        Section {
                            Button(role: .destructive) {
                                viewModel.logOut()
                            } label: {
                                Text("Log out")
                            }
                        }
                    } label: {
                        viewModel.segmentedIndex == 0 ? Image(systemName: "list.dash") :
                        Image(systemName: "square.grid.2x2")
                    }
                }
            }
        }
    }
}
