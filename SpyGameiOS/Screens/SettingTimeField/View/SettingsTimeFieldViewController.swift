//
//  SettingsTimeFieldViewController.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 23.01.2023.
//

import UIKit
import SnapKit
import Combine

private enum Constants {
    static let boldFont: UIFont = FontFamily.Montserrat.bold.font(size: 18)
    static let mediumFont: UIFont = FontFamily.Montserrat.medium.font(size: 16)
    static let heightSaveButton: CGFloat = 56
    static let heightView: CGFloat = 320
    static let alphaBackground: CGFloat = 0.5
}

final class SettingsTimeFieldViewController: BaseViewController {
    
    // UI
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let minutesPicker = UIPickerView()
    private let countOfMinutesLabel = UILabel()
    private let saveButton = TappableButton()
    
    // Private
    private var currentCountOfMinutes: Int = 0
    private var valueBounds: (min: Int, max: Int) = (0, 0)
    private var updateNumber: PassthroughSubject<Int, Never>?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        addViews()
        configureLayout()
        configureAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureActions()
    }
    
    // MARK: - Actions
    
    private func configureActions() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapBackground(_:)))
        view.addGestureRecognizer(tapRecognizer)
        containerView.addGestureRecognizer(UITapGestureRecognizer())
        
        saveButton.enableTapping { [weak self] in
            guard let self = self else { return }
            let value = self.minutesPicker.selectedRow(inComponent: 0) + 1
            if self.valueBounds.min <= value && self.valueBounds.max >= value {
                self.updateNumber?.send(value)
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc private func tapBackground(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    // MARK: - Private
    
    private func addViews() {
        view.addSubview(containerView)
        containerView.addSubviews(titleLabel, minutesPicker, saveButton)
        minutesPicker.addSubview(countOfMinutesLabel)
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(CGFloat.extraLargeMargin)
            $0.center.equalToSuperview()
            $0.height.equalTo(Constants.heightView)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(CGFloat.baseMargin)
            $0.leading.trailing.equalToSuperview()
        }
        minutesPicker.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(saveButton.snp.top)
        }
        countOfMinutesLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.trailing.equalToSuperview().inset(CGFloat.extraLargeMargin)
        }
        saveButton.snp.makeConstraints {
            $0.height.equalTo(Constants.heightSaveButton)
            $0.leading.trailing.bottom.equalToSuperview().inset(CGFloat.baseMargin)
        }
    }
    
    private func configureAppearance() {
        containerView.backgroundColor = Asset.Colors.mainBackgroundColor.color
        containerView.layer.cornerRadius = .baseRadius
        view.backgroundColor = .gray.withAlphaComponent(Constants.alphaBackground)
        // Labels
        titleLabel.font = Constants.boldFont
        titleLabel.textColor = Asset.Colors.mainTextColor.color
        titleLabel.textAlignment = .center
        countOfMinutesLabel.text = L10n.SettingsCell.minute
        countOfMinutesLabel.font = Constants.boldFont
        countOfMinutesLabel.textAlignment = .right
        countOfMinutesLabel.font = Constants.mediumFont
        countOfMinutesLabel.textColor = Asset.Colors.mainTextColor.color
        // Date picker
        minutesPicker.delegate = self
        minutesPicker.dataSource = self
        minutesPicker.selectRow(currentCountOfMinutes - 1, inComponent: 0, animated: true)
        // Button
        saveButton.layer.cornerRadius = .baseRadius
        saveButton.layer.masksToBounds = true
        saveButton.setTitle(L10n.SettingsViewController.save, for: .normal)
        saveButton.titleLabel?.font = Constants.mediumFont
        saveButton.setTitleColor(Asset.Colors.mainTextColor.color, for: .normal)
        saveButton.backgroundColor = Asset.Colors.buttonBackgroundColor.color
    }
}

// MARK: - Extensions UIPickerView

extension SettingsTimeFieldViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return valueBounds.max
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        self.currentCountOfMinutes = row + 1
    }
}

// MARK: - Configurable

extension SettingsTimeFieldViewController: Configurable {
    
    struct Model {
        let title: String
        let number: Int
        let valueBounds: (min: Int, max: Int)
        let updateNumber: PassthroughSubject<Int, Never>
    }
    
    func configure(with model: Model) {
        titleLabel.text = model.title
        updateNumber = model.updateNumber
        currentCountOfMinutes = model.number
        valueBounds = model.valueBounds
    }
}
