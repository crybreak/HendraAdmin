//
//  HendraAdminApp.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 11/03/2024.
//

import SwiftUI
import Firebase


@main
struct HendraAdminApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }.onChange(of: scenePhase) {newScenePhase in
            if  newScenePhase == .background {
                print("➡️ main app - background")
                persistenceController.save()
            }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("➡️ AppDelegate - applicationDidFinishLaunching")

        FirebaseApp.configure()
        return true
    }
    
}

