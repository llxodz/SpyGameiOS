//
//  SettingsCountButton.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 17.12.2022.
//

import UIKit
import SnapKit

private enum Constants {
    static let imageSize: CGFloat = 16
    static let insetsButton: CGFloat = 16
    static let offAlpha: CGFloat = 0.25
}

final class CountButton: TappableButton {
    
    // UI
    private let buttomImage = UIImageView()
    
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? backgroundColor?.withAlphaComponent(1) : backgroundColor?.withAlphaComponent(Constants.offAlpha)
            buttomImage.alpha = isEnabled ? 1 : Constants.offAlpha
        }
    }
    
    // MARK: - Init
    
    init(type: CountButtonType) {
        super.init(frame: .zero)
        addViews()
        configureLayout()
        configureAppearance(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addViews() {
        addSubviews(buttomImage)
    }
    
    private func configureLayout() {
        buttomImage.snp.makeConstraints {
            $0.height.width.equalTo(Constants.imageSize)
            $0.center.equalToSuperview()
        }
    }
    
    private func configureAppearance(type: CountButtonType) {
        let tintColor = Asset.Colors.mainTextColor.color
        switch type {
        case .plus:
            buttomImage.image = Asset.ImageCell.plusImage.image.withTintColor(tintColor)
        case .minus:
            buttomImage.image = Asset.ImageCell.minusImage.image.withTintColor(tintColor)
        }
        backgroundColor = Asset.Colors.buttonBackgroundColor.color
        layer.cornerRadius = CGFloat.smallRadius
        layer.masksToBounds = true
        setInsetsOffset(Constants.insetsButton)
    }
}
