//
//  StartGameButton.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 12.03.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let selectedAlpha: CGFloat = 0.3
    static let whiteSelected: CGFloat  = 0.5
    static let titleFont: UIFont = FontFamily.Montserrat.bold.font(size: 16)
}

final class StartGameButton: UIButton {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func configure() {
        backgroundColor = Asset.buttonStartColor.color
        layer.masksToBounds = true
        layer.cornerRadius = .baseRadius
        setTitle(L10n.FooterView.startGame, for: .normal)
        setTitleColor(Asset.blackTextColor.color, for: .normal)
        setTitleColor(
            UIColor.init(white: Constants.whiteSelected, alpha: Constants.selectedAlpha),
            for: .highlighted
        )
        titleLabel?.font = Constants.titleFont
    }
}
