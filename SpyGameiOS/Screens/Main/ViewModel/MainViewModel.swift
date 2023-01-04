//
//  MainViewModel.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 03.01.2023.
//

import Foundation

class MainViewModel {
    
    private var fields: [SettingsTableViewCell.Model] = [
        SettingsCellType.players.cellModel(),
        SettingsCellType.spies.cellModel(),
        SettingsCellType.timer.cellModel()
    ]
    
    func getFields() -> [SettingsTableViewCell.Model] {
        return fields
    }
    
    func getField(_ indexPath: IndexPath) -> SettingsTableViewCell.Model {
        return fields[indexPath.row]
    }
    
    func setValuesInField(indexPath: IndexPath, field: SettingsTableViewCell.Model) {
        fields[indexPath.row] = field
    }
}
