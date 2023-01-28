//
//  SettingsTimeViewController.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 23.01.2023.
//

import Foundation

final class SettingsTimeViewModel {
    
    // Private property
    private let data: SettingsTableViewCell.Model
    
    // MARK: - Init
    
    init(data: SettingsTableViewCell.Model) {
        self.data = data
    }
    
    // MARK: - Public
    
    func getData() -> SettingsTableViewCell.Model {
        return data
    }
}
