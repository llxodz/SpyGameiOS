//
//  MainViewModel.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 03.01.2023.
//

import UIKit
import Combine

// MARK: - Input & Output

extension MainViewModel {
    
    struct Input {
        /// Нажатие на ячейку
        let clickedOnCell: AnyPublisher<CellType?, Never>
        /// Старт
        let clickedStart: AnyPublisher<Void, Never>
        /// viewDidLoad
        let viewDidLoad: AnyPublisher<Void, Never>
    }
    
    struct Output {
        /// Доступность кнопки старт
        let availabilityStart: AnyPublisher<Bool, Never>
        /// Информация о загрузке категорий
        let categoriesState: AnyPublisher<CategoriesState, Never>
    }
}

// MARK: - MainViewModel

final class MainViewModel: BaseViewModel {
    
    // Dependencies
    private let navigation: MainNavigation
    private let networkRepository: INetworkRepository
    
    // Public property
    let cells: [CellType] = CellType.allCases
    private(set) var categories: [Category] = []
    
    // Private property
    private let availabilityStart = PassthroughSubject<Bool, Never>()
    private let categoriesState = PassthroughSubject<CategoriesState, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var concellablesNetwork = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(navigation: MainNavigation, networkRepository: INetworkRepository) {
        self.navigation = navigation
        self.networkRepository = networkRepository
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
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }
                self.networkRepository.fetchCategories()
                    .sink {
                        switch $0 {
                        case .success(let gamingCategories):
                            self.categories = gamingCategories.map { gc in
                                Category(id: gc.id, name: gc.name, selected: false)
                            }
                        default: break
                        }
                        self.categoriesState.send($0)
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
        
        return Output(
            availabilityStart: availabilityStart.receive(on: DispatchQueue.main).eraseToAnyPublisher(),
            categoriesState: categoriesState.receive(on: DispatchQueue.main).eraseToAnyPublisher()
        )
    }
    
    // MARK: - Helpers
    
    func settingCellModel(for type: CellType?) -> SettingsViewCell.Model {
        switch type {
        case .playes:
            return SettingsViewCell.Model(
                icon: Asset.playerImage.image,
                titleText: L10n.SettingsCell.players,
                secondText: "5"
            )
        case .spies:
            return SettingsViewCell.Model(
                icon: Asset.spyImage.image,
                titleText: L10n.SettingsCell.spys,
                secondText: "2"
            )
        case .timer:
            return SettingsViewCell.Model(
                icon: Asset.clockImage.image,
                titleText: L10n.SettingsCell.timer,
                secondText: "40 мин"
            )
        default:
            return SettingsViewCell.Model(icon: UIImage(), titleText: "", secondText: "")
        }
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
