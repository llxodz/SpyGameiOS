//
//  SettingsTaleViewCell.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 15.08.2022.
//

import UIKit
import SnapKit

private enum Constants {
    static let sizeImage: CGFloat = 24
    
    static let mainBlackColor = Asset.mainBlackColor.color
    
    static let titleFont = FontFamily.Montserrat.medium.font(size: 16)
}

class SettingsTableViewCell: UITableViewCell {
    
    // Public property
    public static var identifier: String {
        String(describing: self)
    }
    
    // UI
    private lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textColor = Constants.mainBlackColor
        return label
    }()
    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.arrowRightImage.image
        return imageView
    }()
    private lazy var countTextLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textColor = Constants.mainBlackColor
        return label
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addViews() {
        [infoImageView, titleTextLabel, arrowImageView, countTextLabel].forEach {
            addSubview($0)
        }
    }
    
    private func configureLayout() {
        infoImageView.snp.makeConstraints {
            $0.height.width.equalTo(Constants.sizeImage)
            $0.leading.equalToSuperview().offset(CGFloat.baseMargin)
            $0.top.bottom.equalToSuperview().inset(CGFloat.compactMargin)
        }
        
        titleTextLabel.snp.makeConstraints {
            $0.leading.equalTo(infoImageView.snp.trailing).offset(CGFloat.smallMargin)
            $0.center.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints {
            $0.height.width.equalTo(Constants.sizeImage)
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin)
            $0.top.bottom.equalToSuperview().inset(CGFloat.compactMargin)
        }
        
        countTextLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(CGFloat.compactMargin)
            $0.trailing.equalTo(arrowImageView.snp.trailing).inset(CGFloat.extraLargeMargin)
        }
    }
}

// MARK: - Configurable

extension SettingsTableViewCell: Configurable {
    
    struct Model {
        let title: String
        let type: TypeCell
    }
    
    enum TypeCell {
        case player, spy, timer
    }
    
    func configure(with model: Model) {
        titleTextLabel.text = model.title
        switch model.type {
            case .player:
                infoImageView.image = Asset.playerImage.image
                countTextLabel.text = "4"
            case .spy:
                infoImageView.image = Asset.spyImage.image
                countTextLabel.text = "1"
            case .timer:
                infoImageView.image = Asset.clockImage.image
                countTextLabel.text = "1 мин."
        }
    }
}
