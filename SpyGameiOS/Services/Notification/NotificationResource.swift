//
//  NotificationResource.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 10.04.2023.
//

import Foundation
import UserNotifications

struct NotificationResource {
    let id: String
    let content: UNNotificationContent
    let timeInterval: TimeInterval
}
