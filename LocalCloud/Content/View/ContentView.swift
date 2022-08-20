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
                ListView(viewModel: ListViewViewModel(items: viewModel.items))
            } else {
                GridView()
            }
        }
        .navigationTitle("Documents")
        .onAppear(perform: {
            viewModel.getAllFiles()
        })
        .sheet(isPresented: $viewModel.isShowingImagePicker, content: {
            ImagePicker(viewModel: ImagePickerViewModel())
        })
        .sheet(isPresented: $viewModel.isShowingDocumentPicker, content: {
            DocumentPicker(viewModel: DocumentPickerViewModel())
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
                                HStack {
                                    Text("List")
                                    Spacer()
                                    Image(systemName: "list.dash")
                                }.tag(0)
                            
                                HStack {
                                    Text("Grid")
                                    Image(systemName: "square.grid.2x2")
                                }.tag(1)
                            }
                        }
                        Section {
                            Button {
                                viewModel.addFolder()
                            } label: {
                                HStack {
                                Text("Add folder")
                                    Image(systemName: "folder.badge.plus")
                                }
                            }
                            Button {
                                viewModel.openImagePicker()
                            } label: {
                                HStack {
                                Text("Add image")
                                    Image(systemName: "photo.on.rectangle")
                                }
                            }
                            Button {
                                viewModel.isShowingDocumentPicker.toggle()
                            } label: {
                                HStack {
                                Text("Add document")
                                    Image(systemName: "doc.on.doc")
                                }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            let context = CoreDataManager.shared.viewContext
            ContentView(viewModel: ContentViewViewModel(currentUser: UserInfo()))
        }
    }
}
