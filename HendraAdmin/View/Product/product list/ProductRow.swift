//
//  ProductRow.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 13/03/2024.
//

import SwiftUI

struct ProductRow: View {
   
    @ObservedObject var product: Product
    @State private var thumbnailUIImage: UIImage? = nil

    
    @State private var showRenameEditor: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var selectionDetent: PresentationDetent = .medium

    var body: some View {
        Group {
            HStack (spacing: 20) {
                if let thumbnail = thumbnailUIImage {
                    Image(uiImage: thumbnail)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }
                
                VStack  (alignment: .leading, spacing: 4){
                    Text(product.type.rawValue)
                        .foregroundStyle(.primary)
                        .font(.system(size: 15))
                    
                    Text(product.name)
                        .font(.footnote)
                    if product.genre.count > 0 {
                        Text(product.genre)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 5)
                            .background(RoundedRectangle(cornerRadius: 5,
                                                         style: .continuous).fill(Color.gray))
                    } else {
                        Text(product.creationDate,  formatter: itemFormatter)
                            .font(.footnote)
                    }
                    if product.user != nil {
                        
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            
                            Text(product.user!.country.rawValue)
                            
                        }
                        .font(.footnote)
                        .foregroundStyle(Color(hex: "E15F39")!)
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
            thumbnailUIImage = await product.usdz.first?.getThumbnail()
        }
    }
}

#Preview {
    ProductRow(product: Product.example())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
