//
//  ImagePicker.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 14.08.2022.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @ObservedObject var viewModel: ImagePickerViewModel
    @Binding var imageURL: URL?
    @Binding var alertMessage: String
    @Binding var showAlert: Bool
    @Environment(\.presentationMode) private var presentationMode
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.mediaTypes = ["public.image", "public.movie", "kUTTypeLivePhoto"]
        picker.allowsEditing = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let imagePicker: ImagePicker
        init(imagePicker: ImagePicker) {
            self.imagePicker = imagePicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            var targetURL: URL?
            if let image = info[.livePhoto] as? PHLivePhoto {
                print(image)
//                targetURL = url
            }
            if let url = info[.imageURL] as? URL {
                print(url.lastPathComponent)
                targetURL = url
            } else if let url = info[.mediaURL] as? URL {
                print(url.lastPathComponent)
                targetURL = url
            }
            guard let targetURL = targetURL else { return }
            guard imagePicker.viewModel.validateFileSize(targetURL) else {
                imagePicker.alertMessage = "File size more then 20MB"
                imagePicker.showAlert = true
                return
            }
            guard imagePicker.viewModel.validateFileExtension(targetURL) else {
                imagePicker.alertMessage = "Forbidden file extension"
                imagePicker.showAlert = true
                return
            }
            imagePicker.imageURL = targetURL
            imagePicker.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            imagePicker.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(imagePicker: self)
    }
}
