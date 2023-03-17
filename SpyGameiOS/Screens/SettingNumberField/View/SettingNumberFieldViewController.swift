//
//  SettingNumberFieldViewController.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 17.12.2022.
//

import UIKit
import SnapKit

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
    
    // UI
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private let minusCountButton = CountButton(type: .minus)
    private let plusCountButton = CountButton(type: .plus)
    private let saveButton = TappableButton()
    private let stackView = UIStackView()
    
    // MARK: - Init
    
    override init() {
        super.init()
        addViews()
        configureLayout()
        configureAppearance()
        configureActions()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    private func configureActions() {
        plusCountButton.enableTapping {
            print("log: plus")
        }
        minusCountButton.enableTapping {
            print("log: minus")
        }
        saveButton.enableTapping { [weak self] in
            self?.dismiss(animated: true)
        }
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
        countLabel.text = "3"
        titleLabel.text = "Title"
        // Save Button
        saveButton.layer.cornerRadius = .baseRadius
        saveButton.setTitle(L10n.SettingsViewController.save, for: .normal)
        saveButton.titleLabel?.font = Constants.saveButtonFont
        saveButton.setTitleColor(Asset.mainTextColor.color, for: .normal)
        saveButton.backgroundColor = Asset.buttonBackgroundColor.color
    }
}
