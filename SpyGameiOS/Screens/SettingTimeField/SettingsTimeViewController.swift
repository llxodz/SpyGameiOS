//
//  SettingsTimeViewController.swift
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
    static let heightCloseButton: CGFloat = 32
    static let heightView: CGFloat = 320
    
    static let alphaBackground: CGFloat = 0.5
}

final class SettingsTimeViewController: BaseViewController {
    
    // Public property
    public var handler: ((SettingsViewCell.Model) -> Void)?
    
    // Private property
    private var viewModel: SettingsTimeViewModel
    
    // UI
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = .baseRadius
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel.getData().titleText
        label.font = Constants.labelFont
        label.textColor = Asset.mainTextColor.color
        return label
    }()
    private lazy var closeImageButton: TappableButton = {
        let button = TappableButton()
        button.backgroundColor = Asset.buttonBackgroundColor.color
        button.setImage(Asset.closeImage.image, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = CGFloat.mediumRadius
        return button
    }()
    private lazy var datePicker = UIDatePicker()
    private lazy var saveSettingsButton: TappableButton = {
        let button = TappableButton()
        button.layer.cornerRadius = .baseRadius
        button.layer.masksToBounds = true
        button.setTitle(L10n.SettingsViewController.save, for: .normal)
        button.titleLabel?.font = Constants.saveButtonFont
        button.setTitleColor(Asset.mainBackgroundColor.color, for: .normal)
        button.backgroundColor = Asset.buttonBackgroundColor.color
        return button
    }()
    
    // MARK: - Init
    
    init(data: SettingsViewCell.Model) {
        self.viewModel = SettingsTimeViewModel(data: data)
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        addViews()
        configureLayout()
        configureAppearance()
        configureButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func addViews() {
        view.addSubview(backgroundView)
        backgroundView.addSubviews(titleLabel, closeImageButton, datePicker, saveSettingsButton)
    }
    
    private func configureLayout() {
        backgroundView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(CGFloat.extraLargeMargin)
            $0.trailing.equalTo(view.snp.trailing).inset(CGFloat.extraLargeMargin)
            $0.center.equalTo(view.center)
            $0.height.equalTo(Constants.heightView)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(backgroundView.snp.leading).offset(CGFloat.baseMargin)
            $0.trailing.equalTo(closeImageButton.snp.leading)
            $0.centerY.equalTo(closeImageButton.snp.centerY)
        }
        closeImageButton.snp.makeConstraints {
            $0.height.width.equalTo(Constants.heightCloseButton)
            $0.top.equalTo(backgroundView.snp.top).offset(CGFloat.baseMargin)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalTo(backgroundView.snp.trailing).inset(CGFloat.baseMargin)
        }
        datePicker.snp.makeConstraints {
            $0.top.equalTo(closeImageButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(saveSettingsButton.snp.top)
        }
        saveSettingsButton.snp.makeConstraints {
            $0.height.equalTo(Constants.heightSaveButton)
            $0.leading.equalTo(backgroundView.snp.leading).offset(CGFloat.baseMargin)
            $0.trailing.equalTo(backgroundView.snp.trailing).inset(CGFloat.baseMargin)
            $0.bottom.equalTo(backgroundView.snp.bottom).inset(CGFloat.baseMargin)
        }
    }
    
    private func configureAppearance() {
        backgroundView.backgroundColor = .white
        view.backgroundColor = .gray.withAlphaComponent(Constants.alphaBackground)
        
        datePicker.datePickerMode = .countDownTimer
    }
    
    private func configureButtons() {
        saveSettingsButton.enableTapping { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
        closeImageButton.enableTapping { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }
    }
}
