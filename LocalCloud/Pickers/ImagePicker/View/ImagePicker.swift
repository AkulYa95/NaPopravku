//
//  MediaPicker.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 14.08.2022.
//

import SwiftUI
import PhotosUI

struct MediaPicker: UIViewControllerRepresentable {
    
    @ObservedObject var viewModel: ImagePickerViewModel
    @Binding var imageURL: URL?
    @Binding var alertMessage: String
    @Binding var showAlert: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .any(of: [.images, .videos])
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .automatic
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if !Thread.isMainThread {
                DispatchQueue.main.async {
                    self.picker(picker, didFinishPicking: results)
                }
                return
            }
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }
            guard provider.canLoadObject(ofClass: PHLivePhoto.self) == false else {
                mediaPicker.alertMessage = "Forbidden extension (livePhoto)"
                mediaPicker.showAlert = true
                return
            }
            
            provider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, _ in
                DispatchQueue.main.async {
                    guard let url = url else { return }
                    guard self.mediaPicker.viewModel.validateFileSize(url) == true else {
                        self.mediaPicker.alertMessage = "Oversize! More then 20MB"
                        self.mediaPicker.showAlert = true
                        return
                    }
                    self.mediaPicker.imageURL = url
                }
            }
            
            provider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, _ in
                DispatchQueue.main.async {
                    guard let url = url else { return }
                    guard self.mediaPicker.viewModel.validateFileSize(url) == true else {
                        self.mediaPicker.alertMessage = "Oversize! More then 20MB"
                        self.mediaPicker.showAlert = true
                        return
                    }
                    self.mediaPicker.imageURL = url
                }
            }
        }
        
        var mediaPicker: MediaPicker
        init(_ photoPicker: MediaPicker) {
            self.mediaPicker = photoPicker
        }
    }
    
    typealias UIViewControllerType = PHPickerViewController
    
}
