//
//  UserListView.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 12/03/2024.
//

import SwiftUI

struct UserListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var stateManager: NavigationStateManager

    @FetchRequest(fetchRequest: Users.fetch(.all))
    private var users: FetchedResults<Users>
       
    @State private var showUser: Bool = false

    var body: some View {
        
        List (selection: $stateManager.selectedUser ){
            UserSortedView(predicate: stateManager.predicate)
            .listRowInsets(.init(top: 5, leading: 20, bottom: 5, trailing: 0))
        }
        .searchable(text: $stateManager.searchUser)
        .listStyle(.plain)
        .toolbar {
                ToolbarItem(placement: .status) {
                    Button {
                        stateManager.addUser(name: "Alfried Doe", country: Country.CI , email: "gossanguy1@gmail.com", phoneNumber: "+229 69593221")
                    }label: {
                        Label("User", systemImage: "person.crop.circle.badge.checkmark")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
        .navigationTitle("Users")
        .onDisappear {
            PersistenceController.shared.save()
        }

    }
    
}

struct UserListView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserListView()
               .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(NavigationStateManager())
        }
    }
}
