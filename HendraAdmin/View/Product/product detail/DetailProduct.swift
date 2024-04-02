//
//  DetailProduct.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 11/03/2024.
//

import SwiftUI
import UniformTypeIdentifiers
import UserNotifications


struct DetailProduct: View {
    @ObservedObject var product: Product
    @EnvironmentObject var stateManager: NavigationStateManager
    @EnvironmentObject var userManager: UserManager

    @State private var showDocumentPicker = false
    @State var selected3D: AttahcmentUSDZ? = nil
    
    
    var selectedProductBinding: Binding<Product> {
        Binding {
            return product
        } set: { newNote in
            stateManager.selectedProduct = product
        }
    }
    
    var body: some View {
        ScrollView  {
            VStack (alignment: .leading){
                if (userManager.message != nil) {
                    MessageView(message: $userManager.message)
                }
                if let selected3D  {
                    Home(product: product, attachment: selected3D)
                }
                LinkedAttachmentUSDZ(product: product, selected3D: $selected3D)
                LinkedAttachmentImage(product: product)
            }
            .navigationTitle($product.name)
            .toolbarTitleMenu(content: {
                RenameButton()
                
                Button(role: .destructive, action: {
                    Product.delete(stateManager.selectedProduct!)
                }, label: {
                    Label("Delete", systemImage: "trash")
                })
            })
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction){
                    Button {
                        showDocumentPicker.toggle()
                    } label: {
                        Image(systemName: "scale.3d")
                    }
                    .sheet(isPresented: $showDocumentPicker, content: {
                        DocumentPicker(product: product, attachment: nil, uttype: [UTType.usdz])
                    })
                    
                    ProductPhotoSelectorButton(product: product, attachment: nil)
                }
                
                ToolbarItemGroup(placement: .status){
                    Button {
                        userManager.product = product
                        userManager.sendProduct.send(product)
                    } label: {
                        Image(systemName: "paperplane.fill")
                    }.disabled(userManager.isLoding)
                }
            }
            .onDisappear {
                PersistenceController.shared.save()
            }
        }
    }
}


struct MessageView: View {
    @Binding var message: String?

    var body: some View {
        
        HStack {
            Image(systemName: "message")
                .foregroundColor(.red)
            
            Text(message ?? "")
                .foregroundColor(.white)
            
            Button(action: {
                message = nil
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color.gray)
                    .padding(.leading)
            })
            
        }
        .padding()
        .font(Font.custom("Nunito Sans", size: 14))


        .background {
            Color(hex: "093855")
        }
        .onAppear {
            withAnimation (.easeOut.delay(2)) {
                message = nil
            }
        }
        .onTapGesture(perform: {
            withAnimation (.easeOut(duration: 2)) {
               message = nil
            }
        })

    }
}

#Preview {
    NavigationView {
        DetailProduct(product: Product.example())
            .environment(\.managedObjectContext,
                          PersistenceController.preview.container.viewContext)
            .environment(\.managedObjectContext,
                          PersistenceController.preview.container.viewContext)
    }
}
