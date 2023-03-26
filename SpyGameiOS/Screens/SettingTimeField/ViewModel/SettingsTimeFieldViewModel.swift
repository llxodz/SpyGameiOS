//
//  SettingsTimeFieldViewModel.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 26.03.2023.
//

import UIKit
import Combine

extension SettingsTimeFieldViewModel {
    
    struct Input {
        /// Начальное значение
        let configureNumber: AnyPublisher<Int, Never>
    }

    struct Output {
        /// Обновить UI
        let updateNumber: AnyPublisher<Int, Never>
    }
}

final class SettingsTimeFieldViewModel: BaseViewModel {
    
    // Public property
    let number = CurrentValueSubject<Int, Never>(0)
    
    // Private property
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public
    
    func transform(input: Input) -> Output {
        input.configureNumber
            .sink { [weak self] value in
                self?.number.send(value)
            }
            .store(in: &cancellables)
        
        return Output(updateNumber: number.eraseToAnyPublisher())
    }
}