//
//  ProductAttachmentUSDZVew.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 17/03/2024.
//

import SwiftUI
import UniformTypeIdentifiers
import CoreData


struct ProductAttachmentUSDZView: View {
    @ObservedObject var product: Product

    @ObservedObject var attachment: AttahcmentUSDZ
    
        
    @Environment(\.pixelLength) var pixelLength
    @Environment(\.displayScale) var displayScale
    
    
    @State private var thumbnailUIImage: UIImage? = nil
    @State private var attachmentID: NSManagedObjectID? = nil
    @State private var presented: Bool = false
    
    var body: some View {
        
        Group {
            if let uiImage = thumbnailUIImage {
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .contextMenu {
                        Button {
                            presented.toggle()
                        } label: {
                            Text("Change usdz")
                        }  .foregroundStyle(attachment.send == true ? .blue : .black)
                        Button {
                            AttahcmentUSDZ.delete(attachment)
                        } label: {
                            Text("Delete usdz")
                        }
                    }
                    .sheet(isPresented: $presented, content: {
                        DocumentPicker(product: product, attachment: attachment, uttype: [UTType.usdz])
                    })

                    
            } else {
                ProgressView("Loding Image...")
                    .frame(minWidth: 300, minHeight: 300)
            }
        }
        .frame(width: 100, height: 100)
        
        .task(id: attachment.data_) {
            thumbnailUIImage = nil
            attachmentID = attachment.objectID
            let newThumbnailImage = await attachment.getThumbnail()

            if self.attachmentID == attachment.objectID {
                thumbnailUIImage = newThumbnailImage
            }
            
        }
    }
}

