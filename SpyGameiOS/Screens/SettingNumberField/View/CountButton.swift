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
}

final class CountButton: TappableButton {
    
    // UI
    private let buttomImage = UIImageView()
    
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
        switch type {
        case .plus: buttomImage.image = Asset.plusImage.image
        case .minus: buttomImage.image = Asset.minusImage.image
        }
        backgroundColor = Asset.buttonStartColor.color
        layer.cornerRadius = CGFloat.smallRadius
        layer.masksToBounds = true
        setInsetsOffset(Constants.insetsButton)
    }
}
