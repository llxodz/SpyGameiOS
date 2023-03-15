//
//  SettingsCellType.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 16.08.2022.
//

import Foundation
import UIKit

enum SettingsCellType: RawRepresentable, CaseIterable {
    case players
    case spies
    case timer
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0: self = .players
        case 1: self = .spies
        case 2: self = .timer
        default: return nil
        }
    }
    
    var rawValue: Int {
        switch self {
        case .players: return 0
        case .spies: return 1
        case .timer: return 2
        }
    }
}

extension SettingsCellType {
    
    // MARK: - Public
    
    func cellModel() -> SettingsViewCell.Model {
        SettingsViewCell.Model(
            icon: icon,
            titleText: titleText,
            countText: countText,
            maxValue: maxValue,
            minValue: minValue,
            fieldType: fieldType
        )
    }
    
    // MARK: - Private
    
    private var icon: UIImage {
        switch self {
        case .players: return Asset.playerImage.image
        case .spies: return Asset.spyImage.image
        case .timer: return Asset.clockImage.image
        }
    }
    
    private var titleText: String {
        switch self {
        case .players: return L10n.SettingsCell.players
        case .spies: return L10n.SettingsCell.spys
        case .timer: return L10n.SettingsCell.timer
        }
    }
    
    // TODO: Надо брать значения из UserDefaults
    private var countText: String {
        switch self {
        case .players: return "4"
        case .spies: return "1"
        case .timer: return "10"
        }
    }
    
    private var maxValue: Int {
        switch self {
        case .players: return 20
        // TODO: Надо брать значения из UserDefaults -> SettingsCellType.players...
        case .spies: return 18
        case .timer: return 120
        }
    }
    
    private var minValue: Int {
        switch self {
        case .players: return 3
        case .spies: return 1
        case .timer: return 1
        }
    }
    
    private var fieldType: SettingsViewCell.FieldType {
        switch self {
        case .players: return .number
        case .spies: return .number
        case .timer: return .timer
        }
    }
}

