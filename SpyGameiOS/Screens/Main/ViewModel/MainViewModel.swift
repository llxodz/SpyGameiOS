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
        /// Обновить ячейки с числами
        let updateSettings: AnyPublisher<Void, Never>
    }
}

// MARK: - MainViewModel

final class MainViewModel: BaseViewModel {
    
    // Dependencies
    private let navigation: MainNavigation
    private let networkRepository: INetworkRepository
    
    // Public property
    let cells: [CellType] = CellType.allCases
    var modelForCategoriesCell: CategoriesViewCell.Model {
        CategoriesViewCell.Model(
            categories: categories,
            availabilityStartWithCategories: availabilityStartWithCategories
        )
    }
    
    // Private property
    private let availabilityStartWithCategories = PassthroughSubject<(Bool, [GameCategory]), Never>()
    private let availabilityStart = CurrentValueSubject<Bool, Never>(false)
    private let categoriesState = PassthroughSubject<CategoriesState, Never>()
    private let updatePlayersCount = PassthroughSubject<Int, Never>()
    private let updateSpiesCount = PassthroughSubject<Int, Never>()
    private let updateMinutesCount = PassthroughSubject<Int, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var categories: [GameCategory] = []
    
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
                guard let self = self else { return }
                self.navigation.goToGame(with: self.makeGameModel())
            }
            .store(in: &cancellables)
        input.viewDidLoad
            .sink { [weak self] in
                guard let self = self else { return }
                self.networkRepository.fetchCategories()
                    .sink {
                        switch $0 {
                        case .success(let data):
                            self.categories = data.map { category in
                                GameCategory(data: category, selected: false)
                            }
                        default: break
                        }
                        self.categoriesState.send($0)
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
        
        // Работа с обновлением настроек
        updatePlayersCount
            .sink { value in
                UserDefaults.standard.settingPlayersCount = value
            }
            .store(in: &cancellables)
        updateSpiesCount
            .sink { value in
                UserDefaults.standard.settingSpiesCount = value
            }
            .store(in: &cancellables)
        updateMinutesCount
            .sink { value in
                UserDefaults.standard.settingMinutesCount = value
            }
            .store(in: &cancellables)
        
        let updateSettings = updatePlayersCount
            .merge(with: updateSpiesCount)
            .merge(with: updateMinutesCount)
            .map { _ in return () }
        
        availabilityStartWithCategories
            .sink { [weak self] (availabilityStartValue, categories) in
                guard let self = self else { return }
                self.availabilityStart.send(availabilityStartValue)
                self.categories = categories
            }
            .store(in: &cancellables)
        
        return Output(
            availabilityStart: availabilityStart.receive(on: DispatchQueue.main).eraseToAnyPublisher(),
            categoriesState: categoriesState.receive(on: DispatchQueue.main).eraseToAnyPublisher(),
            updateSettings: updateSettings.receive(on: DispatchQueue.main).eraseToAnyPublisher()
        )
    }
    
    // MARK: - Helpers
    
    func settingCellModel(for type: CellType?) -> SettingsViewCell.Model {
        switch type {
        case .playes:
            return SettingsViewCell.Model(
                icon: Asset.ImageCell.playerImage.image,
                titleText: L10n.SettingsCell.players,
                secondText: "\(UserDefaults.standard.settingPlayersCount)"
            )
        case .spies:
            return SettingsViewCell.Model(
                icon: Asset.ImageCell.spyImage.image,
                titleText: L10n.SettingsCell.spys,
                secondText: "\(UserDefaults.standard.settingSpiesCount)"
            )
        case .timer:
            return SettingsViewCell.Model(
                icon: Asset.ImageCell.clockImage.image,
                titleText: L10n.SettingsCell.timer,
                secondText: "\(UserDefaults.standard.settingMinutesCount) \(L10n.SettingsCell.minute)"
            )
        default:
            return SettingsViewCell.Model(icon: UIImage(), titleText: "", secondText: "")
        }
    }
    
    // MARK: - Private
    
    private func clickedOnCell(type: CellType?) {
        switch type {
        case .playes:
            navigation.goToNumberField(with: SettingNumberFieldViewController.Model(
                title: L10n.SettingsCell.players,
                number: UserDefaults.standard.settingPlayersCount,
                valueBounds: (UserDefaults.minPlayersCount, UserDefaults.maxPlayersCount),
                updateNumber: updatePlayersCount
            ))
        case .spies:
            navigation.goToNumberField(with: SettingNumberFieldViewController.Model(
                title: L10n.SettingsCell.spys,
                number: UserDefaults.standard.settingSpiesCount,
                valueBounds: (UserDefaults.minSpiesCount, UserDefaults.maxSpiesCount),
                updateNumber: updateSpiesCount
            ))
        case .timer:
            navigation.goToTimeField(with: SettingsTimeFieldViewController.Model(
                title: L10n.SettingsCell.timer,
                number: UserDefaults.standard.settingMinutesCount,
                valueBounds: (UserDefaults.minMinutesCount, UserDefaults.maxMinutesCount),
                updateNumber: updateMinutesCount
            ))
        default: break
        }
    }
    
    private func makeGameModel() -> GameViewModel.Model {
        return GameViewModel.Model(
            playersCount: UserDefaults.standard.settingPlayersCount,
            spiesCount: UserDefaults.standard.settingSpiesCount,
            minutesCount: UserDefaults.standard.settingMinutesCount,
            categories: categories.filter({ $0.selected })
        )
    }
}
