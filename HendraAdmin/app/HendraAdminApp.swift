//
//  HendraAdminApp.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 11/03/2024.
//

import SwiftUI
import Firebase
import CoreData


@main
struct HendraAdminApp: App {
    @AppStorage(wrappedValue: false, AppStorageKeys.hasSeenOnboarding) var hasSeenOnboarding: Bool
    static let subsystem: String = "wilfried.gossan.HendraAdmin"
    

    let persistenceController = PersistenceController.shared
    var context: NSManagedObjectContext { persistenceController.container.viewContext}

    @Environment(\.scenePhase) var scenePhase

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                
                ContentView()
                    .environment(\.managedObjectContext, context)
            } else {
                OnboardingScreen()
            }
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

