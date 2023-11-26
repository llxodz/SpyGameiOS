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
    static let oneMituteInSeconds: Int = 60
    static let oneHourInSeconds: Int = 3600
    static let oneSecond: Double = 1
    static let timerTolerance: Double = 0.1
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
        // Тап кнопки старт\пауза
        let tapButton: AnyPublisher<Void, Never>
        // viewDidDisappear
        let viewDidDisappear: AnyPublisher<Void, Never>
    }
    
    struct Output {
        // Все свайпнули
        let showStart: AnyPublisher<Void, Never>
        // Старт\пауза
        let updateButtonTitle: AnyPublisher<String, Never>
        // Время (c)
        let updateTime: AnyPublisher<String, Never>
    }
    
    // Initial model
    struct Model {
        let playersCount: Int
        let spiesCount: Int
        let minutesCount: Int
        let categories: [GameCategory]
    }
}

// MARK: - GameViewModel

final class GameViewModel: BaseViewModel {
    
    // Dependencies
    private let model: Model
    private let notificationRepository: INotificationRepository
    
    // Private property
    private let showStart = PassthroughSubject<Void, Never>()
    private let updateButtonTitle = CurrentValueSubject<String, Never>(L10n.FooterView.startGame)
    private let updateTime = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var timer: Timer?
    private var seconds: Int
    
    // Public property
    private(set) var cardIsOpen: Bool = false
    private(set) var cardModels: [CardView.Model] = []
    
    // MARK: - Init
    
    init(with model: Model, notificationRepository: INotificationRepository) {
        self.model = model
        self.notificationRepository = notificationRepository
        self.seconds = max(0, model.minutesCount) * Constants.oneMituteInSeconds
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
                self.updateTime.send(self.makeTimeString())
                self.showStart.send()
            }
            .store(in: &cancellables)
        input.tapButton
            .sink { [weak self] in
                guard let self = self else { return }
                if timer == nil {
                    // Старт
                    self.notificationRepository.sendNotification(
                        content: self.configureContentOfNotification()
                    )
                    self.startTimer()
                    self.updateButtonTitle.send(L10n.FooterView.pauseGame)
                } else {
                    // Пауза
                    self.notificationRepository.removeAllPendingNotification()
                    self.stopTimer()
                    self.updateButtonTitle.send(L10n.FooterView.continueGame)
                }
            }
            .store(in: &cancellables)
        input.viewDidDisappear
            .sink { [weak self] in
                guard let self else { return }
                self.notificationRepository.removeAllPendingNotification()
                self.stopTimer()
            }
            .store(in: &cancellables)
        
        return Output(
            showStart: showStart.eraseToAnyPublisher(),
            updateButtonTitle: updateButtonTitle.eraseToAnyPublisher(),
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
            timeInterval: Double(seconds)
        )
    }
}

// MARK: - Timer

private extension GameViewModel {
    
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: Constants.oneSecond, repeats: true) { [weak self] t in
            guard let self, self.seconds > 0 else {
                self?.stopTimer()
                return
            }
            self.seconds -= 1
            self.updateTime.send(makeTimeString())
        }
        timer?.tolerance = Constants.timerTolerance
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func makeTimeString() -> String {
        let formatter = DateComponentsFormatter()
        if seconds < Constants.oneHourInSeconds {
            formatter.allowedUnits = [.second, .minute]
        } else {
            formatter.allowedUnits = [.second, .minute, .hour]
        }
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds)) ?? "\(seconds) sec"
    }
}
