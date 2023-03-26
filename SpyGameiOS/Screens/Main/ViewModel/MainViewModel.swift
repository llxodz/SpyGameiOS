//
//  MainViewModel.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 03.01.2023.
//

import Foundation
import Combine

// MARK: - Input & Output

extension MainViewModel {
    
    struct Input {
        /// Нажатие на ячейку
        let clickedOnCell: AnyPublisher<CellType?, Never>
        /// Старт
        let clickedStart: AnyPublisher<Void, Never>
    }
    
    struct Output {
        /// Доступность кнопки старт
        let availabilityStart: AnyPublisher<Bool, Never>
    }
}

// MARK: - MainViewModel

final class MainViewModel: BaseViewModel {
    
    // Dependencies
    private let navigation: MainNavigation
    
    // Public property
    let cells: [CellType] = CellType.allCases
    
    // Private property
    private let availabilityStart = PassthroughSubject<Bool, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(navigation: MainNavigation) {
        self.navigation = navigation
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        input.clickedOnCell
            .sink { [weak self] type in
                self?.clickedOnCell(type: type)
            }
            .store(in: &cancellables)
        input.clickedStart
            .sink { [weak self] in
                self?.navigation.goToGame()
            }
            .store(in: &cancellables)
        
        return Output(availabilityStart: availabilityStart.eraseToAnyPublisher())
    }
    
    // MARK: - Private
    
    private func clickedOnCell(type: CellType?) {
        switch type {
        case .playes:
            // TODO: - Настроить
            navigation.goToNumberField()
        case .spies:
            // TODO: - Настроить
            navigation.goToNumberField()
        case .timer:
            // TODO: - Настроить
            navigation.goToTimeField()
        default: break
        }
    }
}
