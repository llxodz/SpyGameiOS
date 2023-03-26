//
//  SettingNumberFieldViewModel.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 19.03.2023.
//

import Foundation
import Combine

// MARK: - Input & Output


extension SettingNumberFieldViewModel {
    
    struct Input {
        /// Нажали на кнопки
        let tap: AnyPublisher<CountButtonType, Never>
        /// Начальное значение
        let configureNumber: AnyPublisher<Int, Never>
    }

    struct Output {
        /// Обновить UI
        let updateNumber: AnyPublisher<Int, Never>
    }
}

// MARK: - SettingNumberFieldViewModel

final class SettingNumberFieldViewModel: BaseViewModel {
    
    // Public property
    let number = CurrentValueSubject<Int, Never>(0)
    
    // Private property
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Public
    
    func transform(input: Input) -> Output {
        input.configureNumber
            .sink { [weak self] value in
                var value = value
                if value < 0 { value = 0 }
                self?.number.send(value)
            }
            .store(in: &cancellables)
        input.tap
            .sink { [weak self] type in
                guard let self = self else { return }
                switch type {
                case .minus:
                    let value = max(0, self.number.value - 1)
                    self.number.send(value)
                case .plus:
                    self.number.send(self.number.value + 1)
                }
            }
            .store(in: &cancellables)
        
        return Output(updateNumber: number.eraseToAnyPublisher())
    }
}
