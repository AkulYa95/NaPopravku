//
//  DocumentPicker.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 14.08.2022.
//

import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    @ObservedObject var viewModel: DocumentPickerViewModel
    
    func makeCoordinator() -> Coordinator {
        return DocumentPicker.Coordinator(documentPicker: self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: viewModel.types)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    final class Coordinator: NSObject, UIDocumentPickerDelegate {
        let picker: DocumentPicker
        init(documentPicker: DocumentPicker) {
            self.picker = documentPicker
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            
            guard let url = urls.first,
                  url.startAccessingSecurityScopedResource() else {
                      return
                  }
            defer { url.stopAccessingSecurityScopedResource() }
            do {
                let data = try Data(contentsOf: url)
                print(data)
            } catch {
                print(error.localizedDescription)
            }
            print(url.fileSize)
        }
    }
}
