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

    @State private var columnVisibility: NavigationSplitViewVisibility = .all

   
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
