//
//  CategoriesViewModel.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 12.03.2023.
//

import Foundation
import Combine

// MARK: - Input & Output

extension CategoriesViewModel {
    
    struct Input {
        /// Изменение "Выбрать все"
        let switchAll: AnyPublisher<Bool, Never>
        /// Изменение категории
        let switchCategory: AnyPublisher<Category, Never>
    }

    struct Output {
        /// Измененить положение "Выбрать все"
        let switchAll: AnyPublisher<Bool, Never>
        /// Измененить все переключатели
        let switchAllCategories: AnyPublisher<Bool, Never>
        /// Доступность кнопки старт
        let availabilityStart: AnyPublisher<Bool, Never>
    }
}

// MARK: - CategoriesViewModel

final class CategoriesViewModel: BaseViewModel {
    
    // Dependencies
    private(set) var categories: [Category]
    
    // Property
    private var cancellables = Set<AnyCancellable>()
    private let switchAll = PassthroughSubject<Bool, Never>()
    private let switchAllCategories = PassthroughSubject<Bool, Never>()
    private var availabilityStart = PassthroughSubject<Bool, Never>()
    
    // MARK: - Init
    
    init(categories: [Category]) {
        self.categories = categories
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        input.switchAll
            .sink { [weak self] isOn in
                guard let self = self else { return }
                for (index, _) in self.categories.enumerated() {
                    self.categories[index].selected = isOn
                }
                self.switchAllCategories.send(isOn)
                self.sendAvailabilityStartIfNeeded()
            }
            .store(in: &cancellables)
        input.switchCategory
            .sink { [weak self] item in
                guard let self = self,
                      let index = self.categories.firstIndex(where: { $0.id == item.id }) else {
                    return
                }
                self.categories[index] = item
                self.sendSwitchAllIfNeeded()
                self.sendAvailabilityStartIfNeeded()
            }
            .store(in: &cancellables)
        
        return Output(
            switchAll: switchAll.eraseToAnyPublisher(),
            switchAllCategories: switchAllCategories.eraseToAnyPublisher(),
            availabilityStart: availabilityStart.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Private
    
    private func sendSwitchAllIfNeeded() {
        var count = [Bool: Int]()
        categories.forEach {
            let val = count[$0.selected] ?? 0
            count[$0.selected] = val + 1
        }
        if count[true] == categories.count {
            switchAll.send(true)
        } else {
            switchAll.send(false)
        }
    }
    
    private func sendAvailabilityStartIfNeeded() {
        var count = [Bool: Int]()
        categories.forEach {
            let val = count[$0.selected] ?? 0
            count[$0.selected] = val + 1
        }
        if count[false] == categories.count {
            availabilityStart.send(false)
        } else {
            availabilityStart.send(true)
        }
    }
}
