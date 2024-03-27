//
//  DocumentPicker.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 17/03/2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

@MainActor
struct DocumentPicker: UIViewControllerRepresentable {
   
    @ObservedObject var product: Product
    var attachment: AttahcmentUSDZ?
    
    let uttype: [UTType]
    
    func makeCoordinator() -> Coordinator {
        Coordinator( parent: self, product: product, attachment: attachment)
    }
   
    func makeUIViewController(context: Context) -> some  UIDocumentPickerViewController {
        let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: uttype)
        documentPickerController.allowsMultipleSelection = false
        documentPickerController.delegate = context.coordinator
        return documentPickerController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        var product : Product
        var attachment : AttahcmentUSDZ?

        
        init(parent: DocumentPicker, product: Product, attachment: AttahcmentUSDZ?) {
            self.parent = parent
            self.product = product
            self.attachment = attachment
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first, url.startAccessingSecurityScopedResource() else {return}
    
            do {
                let data = try Data(contentsOf: url) as NSData
                product.addUSDZ(url: url, usdz: data as Data, attachment: attachment)
                
            } catch {
                print(error.localizedDescription)
            }
            controller.dismiss(animated: true)

        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            controller.dismiss(animated: true)
        }
    }
}

