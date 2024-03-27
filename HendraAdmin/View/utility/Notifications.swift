//
//  Notifications.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 27/03/2024.
//

import Foundation
import UserNotifications


func displayNotifications() {
    let identifier = "user-dont-exist"
    let title = "Hendra admin"
    let body = "User don't exist"
    
    let notificationCenter = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
    
    notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    notificationCenter.add(request) { error in
        if let error = error {
            print("Error adding notification request: \(error)")
        } else {
            print("Notification request added successfully")
        }
    }
    
}
