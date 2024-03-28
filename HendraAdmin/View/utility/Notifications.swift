//
//  Notifications.swift
//  HendraAdmin
//
//  Created by Wilfried Mac Air on 27/03/2024.
//

import Foundation
import UserNotifications


func displayNotifications(center: UNUserNotificationCenter)  {
    let title = "Hendra admin"
    let body = "User don't exist"
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default

    let date = Date().addingTimeInterval(5)
    let dateComponenents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
  
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponenents, repeats: false)

    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    center.add(request) { error in
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Notifications test")
        }
        
    }
}
