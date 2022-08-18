//
//  FooterMainView.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 18.08.2022.
//

import UIKit
import SnapKit

private enum Constants {
    static let heightSeparator: CGFloat = 0.5
    static let titleFont: UIFont = FontFamily.Montserrat.bold.font(size: 16)
    
    static let heightButton: CGFloat = 56
    static let selectedAlpha: CGFloat = 0.3
    static let whiteSelected: CGFloat  = 0.5
}

final class FooterMainView: UIView {
    
    // UI
    private lazy var startGameButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = .baseRadius
        button.layer.masksToBounds = true
        button.setTitle(L10n.FooterView.startGame, for: .normal)
        button.titleLabel?.font = Constants.titleFont
        button.setTitleColor(Asset.mainBlackColor.color, for: .normal)
        button.setTitleColor(UIColor.init(
            white: Constants.whiteSelected,
            alpha: Constants.selectedAlpha),
            for: .highlighted
        )
        button.backgroundColor = Asset.buttonStartColor.color
        button.addTarget(self, action: #selector(startGameButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addViews() {
        addSubview(startGameButton)
    }
    
    private func configureLayout() {
        startGameButton.snp.makeConstraints {
            $0.height.equalTo(Constants.heightButton)
            $0.trailing.leading.equalToSuperview().inset(CGFloat.baseMargin)
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc private func startGameButtonTapped() {
        
    }
}
