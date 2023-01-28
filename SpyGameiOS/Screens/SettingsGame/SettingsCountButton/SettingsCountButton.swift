//
//  SettingsCountButton.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 17.12.2022.
//

import UIKit
import SnapKit

enum CountButtonType {
    case plus, minus
}

private enum Constants {
    static let heightButton: CGFloat = 16
    
    static let selectedAlpha: CGFloat = 0.5
    static let normalAlpha: CGFloat = 1
}

final class SettingsCountButton: TappableButton {
    
    // Private property
    private let imageType: CountButtonType
    
    // UI
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.buttonStartColor.color
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat.smallRadius
        return view
    }()
    private lazy var imageButton: UIImageView = UIImageView()
    
    // MARK: - Init
    
    init(imageType: CountButtonType) {
        self.imageType = imageType
        super.init(frame: .zero)
        addViews()
        configureLayout()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addViews() {
        addSubviews(backgroundView, imageButton)
    }
    
    private func configureLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageButton.snp.makeConstraints {
            $0.center.equalTo(backgroundView.snp.center)
            $0.height.width.equalTo(Constants.heightButton)
        }
    }
    
    private func configureAppearance() {
        switch imageType {
        case .plus: imageButton.image = Asset.plusImage.image
        case .minus: imageButton.image = Asset.minusImage.image
        }
    }
}
