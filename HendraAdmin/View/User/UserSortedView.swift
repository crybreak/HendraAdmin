//
//  UserSortedView.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 12/03/2024.
//

import SwiftUI

struct UserSortedView: View {

    init(predicate: NSPredicate) {
        self._users = FetchRequest(fetchRequest: Users.fetch(predicate))
    }
    
    @FetchRequest(fetchRequest: Users.fetch(.none))
    private var users: FetchedResults<Users>
    
    var body: some View {
        ForEach(users) {user in
            UserRow(user: user)
                
        } .onDelete(perform: deleteUsers(offsets:))
    }
    
    
    private func deleteUsers(offsets: IndexSet) {
        withAnimation {
            offsets.map { users[$0] }.forEach(Users.delete(_:))

        }
    }
}

