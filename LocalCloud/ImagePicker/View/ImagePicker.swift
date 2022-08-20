//
//  ImagePicker.swift
//  LocalCloud
//
//  Created by Ярослав Акулов on 14.08.2022.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @ObservedObject var viewModel: ImagePickerViewModel
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let imagePicker: ImagePicker
        init(imagePicker: ImagePicker) {
            self.imagePicker = imagePicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let url = info[.livePhoto] as? URL {
                print(url.lastPathComponent)
            }
            if let url = info[.imageURL] as? URL {
                print(url.lastPathComponent)
            } else if let url = info[.mediaURL] as? URL {
                print(url.lastPathComponent)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(imagePicker: self)
    }
}
