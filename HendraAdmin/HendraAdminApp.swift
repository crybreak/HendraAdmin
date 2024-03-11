//
//  HendraAdminApp.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 11/03/2024.
//

import SwiftUI

@main
struct HendraAdminApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
