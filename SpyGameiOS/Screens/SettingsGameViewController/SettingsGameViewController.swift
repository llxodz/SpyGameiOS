//
//  SettingsGameViewController.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 17.12.2022.
//

import UIKit
import SnapKit

final class SettingsGameViewController: BaseViewController {
    
    private var count: Int = 1
    
    // UI
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Игроки"
        label.font = FontFamily.Montserrat.bold.font(size: 18)
        label.textColor = Asset.mainBlackColor.color
        return label
    }()
    private lazy var closeImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Asset.buttonStartColor.color
        button.setImage(Asset.closeImage.image, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = CGFloat.mediumRadius
        button.addTarget(nil, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var minusCountButton: SettingsCountButton = SettingsCountButton(image: .minusImage)
    private lazy var plusCountButton: SettingsCountButton = SettingsCountButton(image: .plusImage)
    private lazy var stackView: UIStackView = UIStackView()
    private lazy var backgroundStackView = UIView()
    private lazy var saveSettingsButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = .baseRadius
        button.layer.masksToBounds = true
        button.setTitle(L10n.FooterView.startGame, for: .normal)
        button.titleLabel?.font = FontFamily.Montserrat.medium.font(size: 16)
        button.setTitleColor(Asset.mainBlackColor.color, for: .normal)
        button.backgroundColor = Asset.buttonStartColor.color
//        button.addTarget(self, action: #selector(startGameButtonTapped), for: .touchUpInside)
        return button
    }()
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = String(count)
        label.font = FontFamily.Montserrat.bold.font(size: 18)
        label.textColor = Asset.mainBlackColor.color
        return label
    }()
    
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
        view.addSubviews(backgroundView, backgroundStackView)
        
        stackView.addArrangedSubview(minusCountButton)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(plusCountButton)
        
        backgroundView.addSubviews(titleLabel, closeImageButton, stackView, saveSettingsButton)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(backgroundView.snp.leading).offset(16)
            $0.top.equalTo(backgroundView.snp.top).offset(16)
            $0.trailing.equalTo(closeImageButton.snp.leading)
        }
        closeImageButton.snp.makeConstraints {
            $0.height.width.equalTo(32)
            $0.top.equalTo(backgroundView.snp.top).offset(16)
            $0.leading.equalTo(titleLabel.snp.trailing)
            $0.trailing.equalTo(backgroundView.snp.trailing).inset(16)
        }
        backgroundView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading).offset(32)
            $0.trailing.equalTo(view.snp.trailing).inset(32)
            $0.center.equalTo(view.center)
            $0.height.equalTo(256)
        }
        backgroundStackView.snp.makeConstraints {
            $0.top.equalTo(closeImageButton.snp.bottom)
            $0.leading.equalTo(backgroundView.snp.leading)
            $0.trailing.equalTo(backgroundView.snp.trailing)
            $0.bottom.equalTo(saveSettingsButton.snp.top)
        }
        stackView.snp.makeConstraints {
            $0.center.equalTo(backgroundStackView.snp.center)
        }
        minusCountButton.snp.makeConstraints {
            $0.height.width.equalTo(48)
        }
        plusCountButton.snp.makeConstraints {
            $0.height.width.equalTo(48)
        }
        saveSettingsButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.leading.equalTo(backgroundView.snp.leading).offset(16)
            $0.trailing.equalTo(backgroundView.snp.trailing).inset(16)
            $0.bottom.equalTo(backgroundView.snp.bottom).inset(16)
        }
    }
    
    private func configureAppearance() {
        backgroundView.backgroundColor = .white
        stackView.axis = .horizontal
        stackView.spacing = 32
        
        saveSettingsButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        view.backgroundColor = .gray.withAlphaComponent(0.5)
    }
    
    private func configureButtons() {
        minusCountButton.addTapGesture(tapNumber: 1, target: self, action: #selector(minusCountButtonTapped))
//        plusCountButton.addGestureRecognizer(gesturePlus)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func minusCountButtonTapped() {
        print(#function)
    }
    
    @objc private func plusCountButtonTapped() {
        self.count += 1
        print(#function)
    }
    
    @objc private func saveButtonTapped() {
        dismiss(animated: true)
    }
}
