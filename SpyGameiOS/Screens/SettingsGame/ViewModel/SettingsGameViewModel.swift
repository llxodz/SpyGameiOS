//
//  SettingsGameViewModel.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 08.01.2023.
//

import Foundation

final class SettingsGameViewModel {
    
    // Private property
    private var data: SettingsViewCell.Model
    
    // MARK: - Init
    
    init(data: SettingsViewCell.Model) {
        self.data = data
    }
    
    func getData() -> SettingsViewCell.Model {
        return data
    }
}
