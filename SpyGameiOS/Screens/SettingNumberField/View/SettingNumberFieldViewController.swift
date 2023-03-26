//
//  SettingNumberFieldViewController.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 17.12.2022.
//

import UIKit
import SnapKit
import Combine

private enum Constants {
    static let labelFont: UIFont = FontFamily.Montserrat.bold.font(size: 18)
    static let saveButtonFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 16)
    static let sizeCountButton: CGFloat = 48
    static let heightSaveButton: CGFloat = 56
    static let sizeCloseButton: CGFloat = 32
    static let heightView: CGFloat = 256
    static let alphaBackground: CGFloat = 0.5
}

final class SettingNumberFieldViewController: BaseViewController {
    
    // Dependencies
    private let viewModel = SettingNumberFieldViewModel()
    
    // UI
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let minusCountButton = CountButton(type: .minus)
    private let plusCountButton = CountButton(type: .plus)
    private let saveButton = TappableButton()
    private let stackView = UIStackView()
    
    // Private
    private let configureNumber = CurrentValueSubject<Int, Never>(0)
    private let tap = PassthroughSubject<CountButtonType, Never>()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        addViews()
        configureLayout()
        configureAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        configureActions()
    }
    
    // MARK: - Binding & Actions
    
    private func binding() {
        let output = viewModel.transform(input: SettingNumberFieldViewModel.Input(
            tap: tap.eraseToAnyPublisher(),
            configureNumber: configureNumber.eraseToAnyPublisher()
        ))
        output.updateNumber
            .sink { [weak self] value in
                self?.countLabel.text = "\(value)"
            }
            .store(in: &cancellables)
    }
    
    private func configureActions() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapBackground(_:)))
        view.addGestureRecognizer(tapRecognizer)
        containerView.addGestureRecognizer(UITapGestureRecognizer())
        plusCountButton.enableTapping { [weak self] in
            self?.tap.send(.plus)
        }
        minusCountButton.enableTapping { [weak self] in
            self?.tap.send(.minus)
        }
        saveButton.enableTapping { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    @objc private func tapBackground(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    // MARK: - Private
    
    private func addViews() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, stackView, saveButton)
        stackView.addArrangedSubview(minusCountButton)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(plusCountButton)
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.height.equalTo(Constants.heightView)
            $0.leading.equalToSuperview().offset(CGFloat.extraLargeMargin)
            $0.trailing.equalToSuperview().inset(CGFloat.extraLargeMargin)
            $0.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(CGFloat.baseMargin)
            $0.leading.equalToSuperview().offset(CGFloat.baseMargin)
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin)
        }
        stackView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.equalTo(saveButton.snp.top)
        }
        minusCountButton.snp.makeConstraints {
            $0.height.width.equalTo(Constants.sizeCountButton)
        }
        plusCountButton.snp.makeConstraints {
            $0.height.width.equalTo(Constants.sizeCountButton)
        }
        saveButton.snp.makeConstraints {
            $0.height.equalTo(Constants.heightSaveButton)
            $0.leading.equalToSuperview().offset(CGFloat.baseMargin)
            $0.trailing.bottom.equalToSuperview().inset(CGFloat.baseMargin)
        }
    }
    
    private func configureAppearance() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = .baseRadius
        stackView.axis = .horizontal
        stackView.spacing = .extraLargeSpace
        stackView.alignment = .center
        view.backgroundColor = .gray.withAlphaComponent(Constants.alphaBackground)
        // Labels
        titleLabel.textAlignment = .center
        titleLabel.font = Constants.labelFont
        titleLabel.textColor = Asset.mainTextColor.color
        countLabel.font = Constants.labelFont
        countLabel.textColor = Asset.mainTextColor.color
        // Save Button
        saveButton.layer.cornerRadius = .baseRadius
        saveButton.setTitle(L10n.SettingsViewController.save, for: .normal)
        saveButton.titleLabel?.font = Constants.saveButtonFont
        saveButton.setTitleColor(Asset.mainTextColor.color, for: .normal)
        saveButton.backgroundColor = Asset.buttonBackgroundColor.color
    }
}

// MARK: - Configurable

extension SettingNumberFieldViewController: Configurable {
    
    struct Model {
        let title: String
        let number: Int
        let updateNumber: PassthroughSubject<Int, Never>
    }
    
    func configure(with model: Model) {
        titleLabel.text = model.title
        configureNumber.send(model.number)
    }
}
