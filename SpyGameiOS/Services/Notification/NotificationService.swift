//
//  NotificationService.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 08.04.2023.
//

import Foundation
import UserNotifications

// MARK: - INotificationService

protocol INotificationService {
    func requestAuthorization()
    func scheduleNotification(_ resource: NotificationResource)
    func removeAllPendingNotificationRequests()
}

// MARK: - NotificationService

final class NotificationService: NSObject, INotificationService {
    
    // Dependencies
    private let notificationCenter: UNUserNotificationCenter
    
    // MARK: - Init
    
    init(notificationCenter: UNUserNotificationCenter = UNUserNotificationCenter.current()) {
        self.notificationCenter = notificationCenter
        super.init()
        notificationCenter.delegate = self
    }
    
    func requestAuthorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
        }
    }
    
    func scheduleNotification(_ resource: NotificationResource) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: resource.timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: resource.id, content: resource.content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func removeAllPendingNotificationRequests() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void
    ) {
        completionHandler([.banner, .sound, .badge])
    }
}
