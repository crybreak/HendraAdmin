//
//  LinkAttachmentImage.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 20/03/2024.
//

import Foundation
import SwiftUI



func gridItems(for width: CGFloat) -> [GridItem] {
    let numberOfColumns = Int(round(width / 200))
    let item = GridItem(.flexible(minimum: 150, maximum: 350),
                        spacing: 0)
    return Array(repeating: item,
                 count: numberOfColumns)
}
struct LinkedAttachmentImage: View {
    
    @ObservedObject var product: Product
    @Environment(\.managedObjectContext) var viewContext
   
    @State private var selectImage: Date =  Date() + TimeInterval()
        
    var body: some View {
        LazyVGrid(columns: gridItems(for: 393.0),spacing: 2) {
            ForEach(product.images.sorted()) { attachment in
                ZStack (alignment: .topLeading) {
                    ProductAttachementImageView(attachment: attachment)
                        .contextMenu {
                            Button(role: .destructive) {
                                AttahcmentImage.delete(attachment)
                            } label: {
                                Text("Delete image")
                            }
                        }
                    
                    ProductPhotoSelectorButton(product: product, attachment: attachment)
                        .labelStyle(.iconOnly)
                        .imageScale(.medium)
                        .bold()
                        .foregroundColor(attachment.send == false ? .white : .blue)
                        .padding(.top)
                }
            }
        }
    }
                    
}
