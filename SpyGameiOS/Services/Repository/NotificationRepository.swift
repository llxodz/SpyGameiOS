//
//  NotificationRepository.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 08.04.2023.
//

import Foundation
import UserNotifications

// MARK: - INotificationRepository

protocol INotificationRepository {
    func requestAuth()
    func sendNotification(content: NotificationResource)
}

// MARK: - NotificationRepository

final class NotificationRepository: INotificationRepository {
    
    // Dependencies
    private let service: INotificationService
    
    // MARK: - Init
    
    init(service: INotificationService) {
        self.service = service
    }
    
    func requestAuth() {
        service.requestAuthorization()
    }
    
    func sendNotification(content: NotificationResource) {
        service.scheduleNotification(content)
    }
}
