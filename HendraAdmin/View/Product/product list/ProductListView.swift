//
//  ProductListView.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 13/03/2024.
//

import SwiftUI

struct ProductListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var stateManager: NavigationStateManager
    @Environment(\.searchSuggestionsPlacement) var placement

    @FetchRequest(fetchRequest: Product.fetch(.all))
    private var products: FetchedResults<Product>
    
    var selectedUserNameBinding: Binding<String> {
        Binding {
            stateManager.selectedUser?.name ?? ""
        } set: { newValue in
            stateManager.selectedUser?.name = newValue
        }
    }
       
    var body: some View {
        List (selection: $stateManager.selectedProduct ){
        
                ProductSortedView(predicate: stateManager.predicateProduct)
                    .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 0))
        }
        .listStyle(.plain)
        .navigationTitle(selectedUserNameBinding)
        .searchable(text: $stateManager.searchProduct,
                    tokens: $stateManager.searchTokens,
                    suggestedTokens: $stateManager.suggestedTokens,
                    token: {token in
            Label(token.name, systemImage: token.icon())
        })
       
        .navigationBarTitleDisplayMode(.inline)
        .toolbarTitleMenu(content: {
            RenameButton()
            
            Button(role: .destructive, action: {
                Users.delete(stateManager.selectedUser!)
            }, label: {
                Label("Delete", systemImage: "trash")
            })
        })
        .toolbar {
                ToolbarItem(placement: .status) {
                    Button {
                        stateManager.addProduct(name: "Chair", type: "Meuble")
                    }label: {
                        Label("Product", systemImage: "basket.fill")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
        .onDisappear {
            PersistenceController.shared.save()
        }
    }
}

#Preview {
    NavigationView {
        ProductListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(NavigationStateManager())
    }
}
