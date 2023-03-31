//
//  CardView.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 29.03.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let boldFont: UIFont = FontFamily.Montserrat.bold.font(size: 18)
    static let semiBoldFont: UIFont = FontFamily.Montserrat.semiBold.font(size: 14)
}

final class CardView: UIView {
    
    // UI
    private let typeOfPlayerLabel = UILabel()
    private let descriptionOfTypeLabel = UILabel()
    
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
        self.addSubviews(typeOfPlayerLabel, descriptionOfTypeLabel)
    }
    
    private func configureLayout() {
        typeOfPlayerLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        descriptionOfTypeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(CGFloat.baseMargin)
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin).priority(.high)
            $0.bottom.equalToSuperview().inset(CGFloat.baseMargin)
        }
    }
    
    private func configureAppearance() {
        self.backgroundColor = .white
        self.layer.borderWidth = 2
        self.layer.borderColor = Asset.mainTextColor.color.cgColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = .largeRadius
        // Labels
        typeOfPlayerLabel.textAlignment = .center
        typeOfPlayerLabel.font = Constants.boldFont
        typeOfPlayerLabel.textColor = Asset.mainTextColor.color
        typeOfPlayerLabel.text = "Игрок"
        descriptionOfTypeLabel.font = Constants.semiBoldFont
        descriptionOfTypeLabel.textColor = Asset.mainTextColor.color
        descriptionOfTypeLabel.textAlignment = .center
        descriptionOfTypeLabel.numberOfLines = 0
        descriptionOfTypeLabel.text = "Ты игрок балблТы игрок балблТы игрок балблТы игрок балблТы игрок балбл"
    }
}
