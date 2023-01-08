//
//  SettingsGameViewModel.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 08.01.2023.
//

import Foundation

final class SettingsGameViewModel {
    
    // Private property
    private var data: [SettingsTableViewCell.Model]
    private var position: Int
    
    // MARK: - Init
    
    init(data: [SettingsTableViewCell.Model], position: Int) {
        self.data = data
        self.position = position
    }
    
    // MARK: - Public functions
    
    func getData() -> SettingsTableViewCell.Model {
        return data[position]
    }
    
    func getCountText() -> String {
        switch data[position].fieldType {
            case .number: return String(data[position].countText)
            case .timer: return "\(data[position].countText) \(L10n.SettingsCell.minute)"
        }
    }
    
    func plusButtonTapped(complition: @escaping (String) -> Void) {
        guard let role = SettingsCellType(rawValue: position) else { return }
        
        switch role {
        case .players:
            if (data[position].countText - 2 == data[1].countText) {
                data[position].countText += 1
                complition(getCountText())
            } else if (data[self.position].countText == data[self.position].maxValue) {
                complition(getCountText())
            } else {
                data[position].countText += 1
                complition(getCountText())
            }
        case .spies:
            if (data[position].countText + 2 == data[0].countText) {
                complition(getCountText())
            } else if (data[self.position].countText == data[self.position].maxValue) {
                complition(getCountText())
            } else {
                data[position].countText += 1
                complition(getCountText())
            }
        case .timer:
            if data[position].countText != data[position].maxValue {
                data[position].countText += 1
                complition(getCountText())
            }
        }
    }
    
    func minusButtonTapped(complition: @escaping (String) -> Void) {
        guard let role = SettingsCellType(rawValue: position) else { return }
        
        switch role {
        case .players:
            if data[position].countText - 2 != data[1].countText && data[self.position].countText != data[self.position].minValue {
                data[position].countText -= 1
                complition(getCountText())
            }
        case .spies:
            if data[self.position].countText != data[self.position].minValue {
                data[position].countText -= 1
                complition(getCountText())
            }
        case .timer:
            if data[position].countText != data[position].minValue {
                data[position].countText -= 1
                complition(getCountText())
            }
        }
    }
}
