//
//  ProductAttachmentImageView.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 21/03/2024.
//

import SwiftUI
import CoreData


struct ProductAttachementImageView: View {
    @ObservedObject var attachment: AttahcmentImage
    
    
    @State private var showFullImage: Bool = false
    @State private var thumbnailUIImage: UIImage? = nil
    @State private var attachmentID: NSManagedObjectID? = nil
    @State private var presented: Bool = false

        
    @Environment(\.pixelLength) var pixelLength
    @Environment(\.displayScale) var displayScale
    
    var body: some View {
        
        Group {
            if let uiImage = thumbnailUIImage {
                Color.cyan
                    .aspectRatio(1.2, contentMode: .fit)
                    .overlay {
                        Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(nil, contentMode: .fill)
                    }
                    .clipped()
                    .gesture(TapGesture(count: 2).onEnded({ _ in
                        showFullImage.toggle()
                    }))
                    .sheet(isPresented: $showFullImage) {
                        FullImageView(attachment: attachment, title: "full image \(dataSize(data: attachment.fullImageData_)) KB" )
                    }
            } else {
                ProgressView("Loding Image...")
                    .frame(minWidth: 300, minHeight: 300)
            }
        }.frame(width: attachment.imageWidth() * pixelLength,
                height: attachment.imageHeight() * pixelLength)
        
        .task(id: attachment.fullImageData_) {
            thumbnailUIImage = nil
            attachmentID = attachment.objectID
            let newThumbnailImage = await attachment.getThumbnail()
            attachment.updateImageSize(to: thumbnailUIImage?.size)
            
            if self.attachmentID == attachment.objectID {
                thumbnailUIImage = newThumbnailImage
            }
            
        }
    }
}

func dataSize(data: Data?) -> Int {
    if let data = data {
        return data.count / 1024
    } else {
        return 0
    }
}

private struct FullImageView: View {
    
    let attachment: AttahcmentImage
    let title: String
    @State private var image: UIImage? = nil
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                Button("Done") {
                    dismiss()
                }
            }
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                ProgressView("Loding Image...")
                    .frame(minWidth: 300, minHeight: 300)
            }
        }.padding()
            .task {
                self.image = await attachment.createFullImage()
            }
        
    }
}
