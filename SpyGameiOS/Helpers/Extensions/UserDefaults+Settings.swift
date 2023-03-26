//
//  UserDefaults+Settings.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 26.03.2023.
//

import Foundation

extension UserDefaults {
    
    // MARK: - Players
    
    private static let settingPlayersKey: String = "SpyGameiOS.UserDefaults.settingPlayersCount"
    static let minPlayersCount: Int = 3
    static let maxPlayersCount: Int = 20
    
    var settingPlayersCount: Int {
        get {
            let result = object(forKey: UserDefaults.settingPlayersKey) as? Int
            return result ?? UserDefaults.maxPlayersCount
        }
        set {
            var value = max(newValue, UserDefaults.minPlayersCount)
            value = min(value, UserDefaults.maxPlayersCount)
            set(value, forKey: UserDefaults.settingPlayersKey)
            // Update Setting Spies Count
            settingSpiesCount = settingSpiesCount
        }
    }
    
    // MARK: - Spies
    
    private static let settingSpiesKey: String = "SpyGameiOS.UserDefaults.settingSpiesCount"
    static let minSpiesCount: Int = 1
    static var maxSpiesCount: Int {
        return max((UserDefaults.standard.settingPlayersCount - 1) / 2, UserDefaults.minSpiesCount)
    }
    
    var settingSpiesCount: Int {
        get {
            let result = object(forKey: UserDefaults.settingSpiesKey) as? Int
            return result ?? UserDefaults.minSpiesCount
        }
        set {
            var value = max(newValue, UserDefaults.minSpiesCount)
            value = min(value, UserDefaults.maxSpiesCount)
            set(value, forKey: UserDefaults.settingSpiesKey)
        }
    }
}
