//
//  SettingsTimeFieldViewController.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 23.01.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let labelFont: UIFont = FontFamily.Montserrat.bold.font(size: 18)
    static let saveButtonFont: UIFont = FontFamily.Montserrat.medium.font(size: 16)
    static let heightSaveButton: CGFloat = 56
    static let heightView: CGFloat = 320
    static let alphaBackground: CGFloat = 0.5
    static let minutesOfGame: [Int] = Array(1...120)
}

final class SettingsTimeFieldViewController: BaseViewController {
    
    // UI
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let datePicker = UIPickerView()
    private let saveButton = TappableButton()
    
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
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapBackground(_:)))
        view.addGestureRecognizer(tapRecognizer)
        containerView.addGestureRecognizer(UITapGestureRecognizer())
        
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
        containerView.addSubviews(titleLabel, datePicker, saveButton)
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.center.leading.trailing.equalToSuperview().inset(CGFloat.extraLargeMargin)
            $0.height.equalTo(Constants.heightView)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(CGFloat.baseMargin)
            $0.leading.trailing.equalToSuperview()
        }
        datePicker.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(saveButton.snp.top)
        }
        saveButton.snp.makeConstraints {
            $0.height.equalTo(Constants.heightSaveButton)
            $0.leading.trailing.bottom.equalToSuperview().inset(CGFloat.baseMargin)
        }
    }
    
    private func configureAppearance() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = .baseRadius
        view.backgroundColor = .gray.withAlphaComponent(Constants.alphaBackground)
        // Label
        titleLabel.text = "Title"
        titleLabel.font = Constants.labelFont
        titleLabel.textColor = Asset.mainTextColor.color
        titleLabel.textAlignment = .center
        // Date picker
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.selectRow(9, inComponent: 0, animated: true)
        // Button
        saveButton.layer.cornerRadius = .baseRadius
        saveButton.layer.masksToBounds = true
        saveButton.setTitle(L10n.SettingsViewController.save, for: .normal)
        saveButton.titleLabel?.font = Constants.saveButtonFont
        saveButton.setTitleColor(Asset.mainTextColor.color, for: .normal)
        saveButton.backgroundColor = Asset.buttonBackgroundColor.color
    }
}

// MARK: - Extensions UIPickerView

extension SettingsTimeFieldViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.minutesOfGame.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(Constants.minutesOfGame[row]) \(L10n.SettingsCell.minute)"
    }
}
