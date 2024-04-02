//
//  ProductRow.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 13/03/2024.
//

import SwiftUI

struct ProductRow: View {
   
    @ObservedObject var product: Product
    @State private var thumbnailUIImageUSDZ: UIImage? = nil
    @State private var thumbnailUIImage: UIImage? = nil


    
    @State private var showRenameEditor: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var selectionDetent: PresentationDetent = .medium

    var body: some View {
        Group {
            HStack (spacing: 20) {
                if let thumbnail = thumbnailUIImageUSDZ {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                if  thumbnailUIImageUSDZ == nil, let thumbnail = thumbnailUIImage {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                
                
                VStack  (alignment: .leading, spacing: 4){
                    HStack {
                        Text(product.type.rawValue)
                            .foregroundStyle(.primary)
                            .font(.system(size: 15))
                        if product.send {
                            Text("Upload")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 5)
                                .background(RoundedRectangle(cornerRadius: 5,
                                                             style: .continuous).fill(Color(hex: "E15F39")!))
                        } else {
                            Text("Draft")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 5)
                                .background(RoundedRectangle(cornerRadius: 5,
                                                             style: .continuous).fill(Color(hex: "093855")!))
                        }
                    }
                    
                    Text(product.name)
                        .font(.footnote)
                    
                    
                    Text(product.creationDate,  formatter: itemFormatter)
                        .font(.footnote)
                
                    if product.user != nil {
                        
                        HStack {
                            Group {
                                Image(systemName: "mappin.and.ellipse")
                                
                                Text(product.user!.country.rawValue)
                            } .font(.footnote)
                                .foregroundStyle(Color(hex: "E15F39")!)
                            if product.genre.count > 0 {
                                Text(product.genre)
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 5)
                                    .background(RoundedRectangle(cornerRadius: 5,
                                                                 style: .continuous).fill(Color.gray))
                            }
                        }
                       
                    }
                }
            }
        }.contextMenu {
            Button ("Set") {
                showRenameEditor = true
            }
            Button("Delete") {
                showDeleteConfirmation = true
            }
        } .confirmationDialog("Delete", isPresented: $showDeleteConfirmation) {
            Button("Delete") {
                Product.delete(product)
                PersistenceController.shared.save()
            }
        }
        .sheet(isPresented: $showRenameEditor) {
            ProductSetInformationView(product: product)
                .presentationDetents([.fraction(0.25) , .medium],
                selection: $selectionDetent)
        }
        .task {
            thumbnailUIImageUSDZ = await product.usdz.first?.getThumbnail()
            thumbnailUIImage = await product.images.first?.getThumbnail()
        }
    }
}

#Preview {
    ProductRow(product: Product.example())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
