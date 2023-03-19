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
    }

    struct Output {
        /// Обновить UI
        let updateNumber: AnyPublisher<Int, Never>
    }
}

// MARK: - SettingNumberFieldViewModel

final class SettingNumberFieldViewModel: BaseViewModel {
    
    func transform(input: Input) -> Output {
        let subject = PassthroughSubject<Int, Never>()
        return Output(updateNumber: subject.eraseToAnyPublisher())
    }
}
