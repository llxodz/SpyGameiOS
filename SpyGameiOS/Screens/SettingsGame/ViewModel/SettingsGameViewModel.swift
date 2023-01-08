//
//  SettingsGameViewModel.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 08.01.2023.
//

import Foundation

final class SettingsGameViewModel {
    
    private var data: SettingsTableViewCell.Model
    
    init(data: SettingsTableViewCell.Model) {
        self.data = data
    }
    
    func getData() -> SettingsTableViewCell.Model {
        return data
    }
    
    func getCountText() -> String {
        switch data.fieldType {
            case .number: return String(data.countText)
            case .timer: return "\(data.countText) \(L10n.SettingsCell.minute)"
        }
    }
    
    func plusButtonTapped(complition: @escaping (String) -> Void) {
        if !(data.countText == data.maxValue) {
            data.countText += 1
            complition(getCountText())
        }
    }
    
    func minusButtonTapped(complition: @escaping (String) -> Void) {
        if !(data.countText == data.minValue) {
            data.countText -= 1
            complition(getCountText())
        }
    }
}
