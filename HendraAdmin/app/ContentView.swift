//
//  ContentView.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 11/03/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var stateManager = NavigationStateManager()
    @StateObject var userManager = UserManager()
    @Environment(\.managedObjectContext) private var viewContext

    @Environment(\.scenePhase) var scenePhase


    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    @SceneStorage(SceneStorageKeys.user) var userID: String?
    @SceneStorage(SceneStorageKeys.product) var productID: String?
   
    var body: some View {
        NavigationSplitView (columnVisibility: $columnVisibility) {
            UserListView()
        }content: {
            if stateManager.selectedUser != nil {
                ProductListView()
            }
        }detail: {
            if let product = stateManager.selectedProduct{
                DetailProduct(product: product)
            }
        }
        .environmentObject(stateManager)
        .environmentObject(userManager  )
       
        .onReceive (stateManager.$selectedUser.dropFirst()) {user  in
            userID = user?.uuid.uuidString

            
        }
        .onReceive (stateManager.$selectedProduct.dropFirst()) {product  in
            productID = product?.uuid.uuidString
        }
        
        .onChange(of: scenePhase) { newValue in
            guard newValue == .active else {return}
//            restoreState()
        }
    }
    func restoreState() {
        stateManager.restoreState (userID: userID, productID: productID, context: viewContext)

    }
}

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(NavigationStateManager())
        .environmentObject(UserManager())

}
