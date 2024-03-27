//
//  ProductSelectButton.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 20/03/2024.
//


import SwiftUI
import PhotosUI

struct ProductPhotoSelectorButton: View {
    @Environment(\.managedObjectContext) var context
    @ObservedObject var product: Product

    var attachment: AttahcmentImage?

    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
            attachment == nil
            ? Label("import photo", systemImage: "photo")
            : Label("change photo", systemImage: "arrow.uturn.forward.circle")
        }
        .onChange(of: selectedItem) { newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    self.update(data, attachment: attachment)
                }
            }
        }
    }
    
    @MainActor
    func update(_ imageData: Data, attachment: AttahcmentImage?)  {
        product.addImage(imageData: imageData, attachment: attachment)
    }
}
