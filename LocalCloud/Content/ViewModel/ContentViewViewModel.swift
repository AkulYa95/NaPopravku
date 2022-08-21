//
//  ContentViewViewModel.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 13.08.2022.
//

import Combine
import FirebaseAuth

class ContentViewViewModel: ObservableObject {
    
    @Published var segmentedIndex: Int = UserDefaults.standard.integer(forKey: DefaultKeys.segmentedIndex) {
        didSet {
            getAllFiles()
        }
    }
    @Published var filterType: FilterType = .none
    @Published var showImagePicker = false
    @Published var showDocumentPicker = false
    
    @Published var isNeedAlert = false
    @Published var alertMessage = ""
    @Published var parentFolder: FileItem?
    @Published var items: [FileItem] = []
    
    @Published var newFileURL: URL?
    
    @Published var isNeedEditAlert = false
    @Published var itemName: String = ""
    
    @Published var currentUser: UserInfo
    private var cancellableSet: Set<AnyCancellable> = []
    
    var userEmail: String {
        return currentUser.email ?? ""
    }
    
    var isAllowAddFolder: Bool {
        let isLimit = parentFolder?.depthLevel == 0 ? true : false
        return isLimit
    }
    
    var folderName: String {
        parentFolder?.fileName ?? "Folder"
    }
    
    func getAllFiles() {
        guard let id = currentUser.userID,
        let depthLevel = parentFolder?.depthLevel,
        let parentID = parentFolder?.id else {
            return
        }
        if depthLevel == 0 {
            parentFolder = CoreDataManager.shared.fetchRootFolder(withOwnerID: id)?.converted()
        } else {
            parentFolder = CoreDataManager.shared.fetchContentItemsFrom(withOwnerID: id,
                                                                        depthLevel: depthLevel,
                                                                        id: parentID)
        }
        guard let contentItems = parentFolder?.contentItems else { return }
        switch filterType {
        case .onlyFolders:
            parentFolder?.contentItems = contentItems.filter({ $0.fileType == .folder })
        case .none:
            break
        case .onlyFiles:
            parentFolder?.contentItems = contentItems.filter({ $0.fileType == .file })
        }
    }
    
    func addFolder() {
        guard let parentFolder = parentFolder,
              let userID = currentUser.userID,
              let entity = CoreDataManager.shared.fetchRootFolder(withOwnerID: userID),
              let itemsData = entity.contentItems,
              var entityItems = try? JSONDecoder().decode([FileItem]?.self, from: itemsData) else {
                  return
              }
        let folder = FileItem(fileType: .folder,
                              depthLevel: parentFolder.depthLevel + 1,
                              id: UUID(),
                              ownerID: currentUser.userID,
                              url: nil,
                              fileName: "New Folder",
                              parentId: parentFolder.parentId)
        
        entityItems.insert(folder, at: 0)
        entity.contentItems = try? JSONEncoder().encode(entityItems)
        CoreDataManager.shared.save()
        getAllFiles()
    }
    
    func openImagePicker() {
        getAllFiles()
        GalleryHelper.getRequestForImagePicker { isSuccess in
            DispatchQueue.main.async {
                guard isSuccess == true else {
                    self.alertMessage = "Problem with access"
                    self.isNeedAlert.toggle()
                    return
                }
                self.showImagePicker.toggle()
            }
        }
    }
    
    func openDocumentPicker() {
        getAllFiles()
        showDocumentPicker.toggle()
    }
    
    func logOut() {
        let auth = Auth.auth()
        try? auth.signOut()
        currentUser.token = nil
        currentUser.userID = nil
    }
    
    private func addFile() {
        guard let url = newFileURL,
        let parentFolder = parentFolder,
        let userID = currentUser.userID,
        var contentItems = parentFolder.contentItems else { return }
        let fileName = url.lastPathComponent
        let file = FileItem(fileType: .file,
                            depthLevel: parentFolder.depthLevel,
                            id: UUID(),
                            ownerID: userID,
                            url: newFileURL,
                            fileName: fileName,
                            parentId: parentFolder.id)
        contentItems.insert(file, at: 0)
        CoreDataManager.shared.saveNewFile(file,
                                           ownerID: userID)
        newFileURL = nil
        getAllFiles()
        
    }
        
    init(currentUser: UserInfo, parentFolder: FileItem?) {
        self.currentUser = currentUser
        self.parentFolder = parentFolder
        if let parentFolder = parentFolder,
           let items = parentFolder.contentItems {
            self.items = items
        }
        $segmentedIndex
            .receive(on: RunLoop.main)
            .sink(receiveValue: { UserDefaults.standard.set($0, forKey: DefaultKeys.segmentedIndex) })
            .store(in: &cancellableSet)
        $newFileURL
            .receive(on: RunLoop.main)
            .sink(receiveValue: { _ in self.addFile() })
            .store(in: &cancellableSet)
        $filterType
            .receive(on: RunLoop.main)
            .sink { _ in self.getAllFiles() }
            .store(in: &cancellableSet)
    }
}
