//
//  CardView.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 29.03.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let boldFont: UIFont = FontFamily.Montserrat.bold.font(size: 24)
    static let semiBoldFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 14)
    static let borderWidth: CGFloat = 2
    static let imageSize: CGFloat = 64
}

final class CardView: UIView {
    
    // UI
    private let typeOfPlayerLabel = UILabel()
    private let descriptionOfTypeLabel = UILabel()
    private let imageView = UIImageView()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configureLayout()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addViews() {
        self.addSubviews(typeOfPlayerLabel, descriptionOfTypeLabel, imageView)
    }
    
    private func configureLayout() {
        typeOfPlayerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(CGFloat.baseMargin)
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin).priority(.high) // Priotity нужен для фикса логов
            $0.centerY.equalToSuperview()
        }
        descriptionOfTypeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(CGFloat.baseMargin)
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin).priority(.high) // Priotity нужен для фикса логов
            $0.bottom.equalToSuperview().inset(CGFloat.baseMargin)
        }
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(CGFloat.extraLargeMargin)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(Constants.imageSize)
        }
    }
    
    private func configureAppearance() {
        self.backgroundColor = Asset.Colors.buttonBackgroundColor.color
        self.layer.borderWidth = Constants.borderWidth
        self.layer.borderColor = Asset.Colors.mainTextColor.color.cgColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = .largeRadius
        // Labels
        typeOfPlayerLabel.textAlignment = .center
        typeOfPlayerLabel.font = Constants.boldFont
        typeOfPlayerLabel.textColor = Asset.Colors.mainTextColor.color
        typeOfPlayerLabel.text = L10n.CardView.startName
        typeOfPlayerLabel.numberOfLines = 0
        descriptionOfTypeLabel.font = Constants.semiBoldFont
        descriptionOfTypeLabel.textColor = Asset.Colors.mainTextColor.color
        descriptionOfTypeLabel.textAlignment = .center
        descriptionOfTypeLabel.numberOfLines = 0
        descriptionOfTypeLabel.text = L10n.CardView.startDescription
        // Image
        imageView.image = Asset.tapImage.image.withTintColor(Asset.Colors.mainTextColor.color)
    }
}

extension CardView: Configurable {
    
    struct Player {
        let type: PlayerType
        let location: String
    }
    
    func configure(with model: Player) {
        switch model.type {
        case .normalPlayer:
            typeOfPlayerLabel.text = model.location
            descriptionOfTypeLabel.text = L10n.CardView.commonPlayerDescription
        case .spyPlayer:
            typeOfPlayerLabel.text = L10n.CardView.spyName
            descriptionOfTypeLabel.text = L10n.CardView.spyDescription
        }
        imageView.image = Asset.swipeImage.image.withTintColor(Asset.Colors.mainTextColor.color)
    }
}
