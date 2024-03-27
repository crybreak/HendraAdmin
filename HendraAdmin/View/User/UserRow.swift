//
//  UserRow.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 12/03/2024.
//

import SwiftUI

struct UserRow: View {
   
    @ObservedObject var user: Users
    @EnvironmentObject var stateManager: NavigationStateManager


    @State private var showRenameEditor: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var selectionDetent: PresentationDetent = .medium


    
    var body: some View {
        Group {
            HStack (spacing: 0) {
                if let image = ProfilImage(name: user.name).generateProfileImage() {
                    Image (uiImage: image)
                }
               
                
                VStack  (alignment: .leading, spacing: 0){
                    Text(user.name)
                        .bold()
                    
                    Text(user.email)
                        .font(.subheadline)
                    HStack {
                        Text(user.creationDate, formatter: itemFormatter)
                            .font(.caption)
                        Text(user.country.rawValue)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 5)
                            .background(RoundedRectangle(cornerRadius: 5,
                                                         style: .continuous).fill(Color.gray))
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
                    Users.delete(user)
                    PersistenceController.shared.save()
                }
            }
            .sheet(isPresented: $showRenameEditor) {
                UserInformationView(user: user)
                    .presentationDetents([.fraction(0.25) , .medium],
                    selection: $selectionDetent)
            }
        }
        .onTapGesture {
            stateManager.userChanged(to: user)
        }
        .tag(user)

    }
}

#Preview {
    UserRow(user: .nestedUserExemple(context: PersistenceController.preview.container.viewContext))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
