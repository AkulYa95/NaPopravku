//
//  ContentViewViewModel.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 13.08.2022.
//

import CoreData
import Combine
import FirebaseAuth

class ContentViewViewModel: ObservableObject {
    
    @Published var segmentedIndex: Int = UserDefaults.standard.integer(forKey: DefaultKeys.segmentedIndex)
    @Published var isShowingImagePicker = false
    @Published var isShowingDocumentPicker = false
    
    @Published var isNeedAlert = false
    @Published var alertMessage = ""
    
    @Published var items: [FileItem] = []
    
    @Published var isNeedEditAlert = false
    @Published var itemName: String = ""
    
    @Published private var currentUser: UserInfo
    private var cancellableSet: Set<AnyCancellable> = []
    
    var userEmail: String {
        return currentUser.email ?? ""
    }
    
    private func converted(fileEntity: FileEntity) -> FileItem? {
        guard let typeData = fileEntity.type,
              let type = try? JSONDecoder().decode(ItemType.self, from: typeData),
              let fileID = fileEntity.id,
              let fileName = fileEntity.fileName else {
                  return nil
              }
        var file = FileItem(fileType: type,
                            depthLevel: Int(fileEntity.depthLevel),
                            id: fileID,
                            ownerID: fileEntity.ownerID,
                            url: fileEntity.url,
                            fileName: fileName)
        if let data = fileEntity.contentItems {
            file.contentItems = try? JSONDecoder().decode([FileItem]?.self, from: data)
        }
        return file
    }
    
    func getAllFiles() {
        guard let id = currentUser.userID else { return }
        var bufferItems: [FileItem] = []
        CoreDataManager.shared.getAllFiles(withID: id).forEach { entity in
            if let item = converted(fileEntity: entity) {
                bufferItems.insert(item, at: 0)
            }
        }
        items = bufferItems
    }
    
    func addFolder() {
        let entity = FileEntity(context: CoreDataManager.shared.viewContext)
        let folder = FileItem(fileType: .folder,
                              depthLevel: 1,
                              id: UUID(),
                              ownerID: currentUser.userID,
                              url: nil,
                              fileName: "New Folder")
        entity.type = try? JSONEncoder().encode(folder.fileType)
        entity.depthLevel = Int16(folder.depthLevel)
        entity.id = folder.id
        entity.ownerID = folder.ownerID
        entity.url = folder.url
        entity.fileName = folder.fileName
        entity.contentItems = try? JSONEncoder().encode(folder.contentItems)
        CoreDataManager.shared.save()
        getAllFiles()
    }
    
    func openImagePicker() {
        GalleryHelper.getRequestForImagePicker { isSuccess in
            DispatchQueue.main.async {
                guard isSuccess == true else {
                    self.alertMessage = "Problem with access"
                    self.isNeedAlert.toggle()
                    return
                }
                self.isShowingImagePicker.toggle()
            }
        }
    }
    
    func logOut() {
        let auth = Auth.auth()
        try? auth.signOut()
        currentUser.token = nil
        currentUser.userID = nil
    }
    
    func save() {
        let file = FileEntity(context: CoreDataManager.shared.viewContext)
        CoreDataManager.shared.save()
        
    }
    
    init(currentUser: UserInfo) {
        self.currentUser = currentUser
        $segmentedIndex
            .receive(on: RunLoop.main)
            .sink(receiveValue: { UserDefaults.standard.set($0, forKey: DefaultKeys.segmentedIndex) })
            .store(in: &cancellableSet)
    }
    
}
