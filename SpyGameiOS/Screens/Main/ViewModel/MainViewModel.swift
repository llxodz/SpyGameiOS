//
//  MainViewModel.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 03.01.2023.
//

import Foundation

final class MainViewModel {
    
    let cells: [CellType] = CellType.allCases
    
    // Private property
    private var fields: [SettingsViewCell.Model] = [
        SettingsCellType.players.cellModel(),
        SettingsCellType.spies.cellModel(),
        SettingsCellType.timer.cellModel()
    ]
    
    // MARK: - Public functions
    
    func getFields() -> [SettingsViewCell.Model] {
        return fields
    }
    
    func getField(_ indexPath: IndexPath) -> SettingsViewCell.Model {
        return fields[indexPath.row]
    }
    
    func setValuesInField(indexPath: IndexPath, field: SettingsViewCell.Model) {
        fields[indexPath.row] = field
    }
}
