//
//  SettingsGameViewController.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 17.12.2022.
//

import UIKit
import SnapKit

private enum Constants {
    static let labelFont: UIFont = FontFamily.Montserrat.bold.font(size: 18)
    static let saveButtonFont: UIFont = FontFamily.Montserrat.medium.font(size: 16)
    
    static let heightCountButton: CGFloat = 48
    static let heightSaveButton: CGFloat = 56
    static let heightCloseButton: CGFloat = 32
    static let heightView: CGFloat = 256
    
    static let alphaBackground: CGFloat = 0.5
}

final class SettingsGameViewController: BaseViewController {
    
    // Public property
    public var handler: ((SettingsViewCell.Model) -> Void)?
    
    // Private property
    private var viewModel: SettingsGameViewModel
    
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
        button.backgroundColor = Asset.buttonStartColor.color
        button.setImage(Asset.closeImage.image, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = CGFloat.mediumRadius
        return button
    }()
    private lazy var minusCountButton: SettingsCountButton = SettingsCountButton(imageType: .minus)
    private lazy var plusCountButton: SettingsCountButton = SettingsCountButton(imageType: .plus)
    private lazy var stackView: UIStackView = UIStackView()
    private lazy var saveSettingsButton: TappableButton = {
        let button = TappableButton()
        button.layer.cornerRadius = .baseRadius
        button.layer.masksToBounds = true
        button.setTitle(L10n.SettingsViewController.save, for: .normal)
        button.titleLabel?.font = Constants.saveButtonFont
        button.setTitleColor(Asset.mainBackgroundColor.color, for: .normal)
        button.backgroundColor = Asset.buttonStartColor.color
        return button
    }()
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.labelFont
        label.textColor = Asset.mainTextColor.color
        label.text = String(describing: viewModel.getData().countText)
        return label
    }()
    
    // MARK: - Init
    
    init(data: SettingsViewCell.Model, handler: ((SettingsViewCell.Model) -> Void)? = nil) {
        self.handler = handler
        self.viewModel = SettingsGameViewModel(data: data)
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        minusCountButton.disableTapping()
        plusCountButton.disableTapping()
        saveSettingsButton.disableTapping()
        closeImageButton.disableTapping()
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        addViews()
        configureLayout()
        configureAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
    }
    
    // MARK: - Private
    
    private func addViews() {
        view.addSubview(backgroundView)
        backgroundView.addSubviews(titleLabel, closeImageButton, stackView, saveSettingsButton)
        stackView.addArrangedSubview(minusCountButton)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(plusCountButton)
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
        stackView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.centerX.equalToSuperview()
            $0.top.equalTo(closeImageButton.snp.bottom)
            $0.bottom.equalTo(saveSettingsButton.snp.top)
        }
        minusCountButton.snp.makeConstraints {
            $0.height.width.equalTo(Constants.heightCountButton)
        }
        plusCountButton.snp.makeConstraints {
            $0.height.width.equalTo(Constants.heightCountButton)
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
        
        stackView.axis = .horizontal
        stackView.spacing = .extraLargeSpace
        stackView.alignment = .center
        
        view.backgroundColor = .gray.withAlphaComponent(Constants.alphaBackground)
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
