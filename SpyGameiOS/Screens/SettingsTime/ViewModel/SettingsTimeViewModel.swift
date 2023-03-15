//
//  SettingsTimeViewController.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 23.01.2023.
//

import Foundation

final class SettingsTimeViewModel {
    
    // Private property
    private let data: SettingsViewCell.Model
    
    // MARK: - Init
    
    init(data: SettingsViewCell.Model) {
        self.data = data
    }
    
    // MARK: - Public
    
    func getData() -> SettingsViewCell.Model {
        return data
    }
}
