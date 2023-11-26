//
//  GameViewModel.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 05.04.2023.
//

import Foundation
import UserNotifications
import Combine

private enum Constants {
    static let pushNotificationId: String = "SpyGameiOS.GameOver"
}

// MARK: - Input & Output

extension GameViewModel {
    
    struct Input {
        // Раскрытие карточки
        let tapCard: AnyPublisher<Void, Never>
        // Смахнули карточку
        let didSwipeCard: AnyPublisher<Void, Never>
        // didSwipeAllCards
        let didSwipeAllCards: AnyPublisher<Void, Never>
        // Старт игры
        let start: AnyPublisher<Void, Never>
    }
    
    struct Output {
        // все свайпнули
        let showStart: AnyPublisher<Void, Never>
        // Время (c)
        let updateTime: AnyPublisher<String, Never>
    }
    
    // Initial model
    struct Model {
        let playersCount: Int
        let spiesCount: Int
        let minutesCount: Int
        let categories: [GameCategory]
        
        var seconds: Int {
            guard minutesCount > 0 else { return 0 }
            return minutesCount * 60
        }
    }
}

// MARK: - GameViewModel

final class GameViewModel: BaseViewModel {
    
    // Dependencies
    private let model: Model
    private let notificationRepository: INotificationRepository
    
    // Private property
    private let showStart = PassthroughSubject<Void, Never>()
    private let updateTime = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // Public property
    private(set) var cardIsOpen: Bool = false
    private(set) var cardModels: [CardView.Model] = []
    
    // MARK: - Init
    
    init(with model: Model, notificationRepository: INotificationRepository) {
        self.model = model
        self.notificationRepository = notificationRepository
        self.cardModels = generateCardModels()
    }
    
    // MARK: - Transform
    
    func transform(input: Input) -> Output {
        input.tapCard
            .sink { [weak self] in
                self?.cardIsOpen = true
            }
            .store(in: &cancellables)
        input.didSwipeCard
            .sink { [weak self] in
                self?.cardIsOpen = false
            }
            .store(in: &cancellables)
        input.didSwipeAllCards
            .sink { [weak self] in
                guard let self = self else { return }
                let timeText = self.makeTimeString(seconds: self.model.seconds)
                self.updateTime.send(timeText)
                self.showStart.send()
            }
            .store(in: &cancellables)
        input.start
            .sink { [weak self] in
                guard let self = self else { return }
                // TODO: - Start timer
                // Локальная нотификация во время окончания игры
                self.notificationRepository.sendNotification(
                    content: self.configureContentOfNotification()
                )
            }
            .store(in: &cancellables)
        return Output(
            showStart: showStart.eraseToAnyPublisher(),
            updateTime: updateTime.eraseToAnyPublisher()
        )
    }
    
    // MARK: - Public
    
    func requestAuthorization() {
        notificationRepository.requestAuth()
    }
    
    // MARK: - Private
    
    private func generateCardModels() -> [CardView.Model] {
        let category = model.categories.randomElement()
        guard let location = category?.data.locations.randomElement() else { return [] }
        var models: [CardView.Model] = []
        for _ in 0..<model.spiesCount {
            models.append(CardView.Model(type: .spyPlayer, location: L10n.CardView.spyName))
        }
        for _ in 0..<(model.playersCount - model.spiesCount) {
            models.append(CardView.Model(type: .normalPlayer, location: location.name))
        }
        return models.shuffled()
    }
    
    private func configureContentOfNotification() -> NotificationResource {
        let content = UNMutableNotificationContent()
        
        content.title = L10n.Notification.title
        content.body = L10n.Notification.description
        content.sound = UNNotificationSound.default
        
        return NotificationResource(
            id: Constants.pushNotificationId,
            content: content,
            timeInterval: Double(model.seconds)
        )
    }
    
    private func makeTimeString(seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        if seconds < 3600 {
            formatter.allowedUnits = [.second, .minute]
        } else {
            formatter.allowedUnits = [.second, .minute, .hour]
        }
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds)) ?? "\(seconds) sec"
    }
}
