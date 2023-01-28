//
//  SettingsGameViewModel.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 08.01.2023.
//

import Foundation

final class SettingsGameViewModel {
    
    // Private property
    private var data: SettingsTableViewCell.Model
    
    // MARK: - Init
    
    init(data: SettingsTableViewCell.Model) {
        self.data = data
    }
    
    func getData() -> SettingsTableViewCell.Model {
        return data
    }
}
