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
        label.textColor = Asset.mainBlackColor.color
        return label
    }()
    private lazy var countTextLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textColor = Asset.mainBlackColor.color
        return label
    }()
    private lazy var infoImageView = UIImageView()
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.arrowRightImage.image
        return imageView
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
            contentView.addSubview($0)
        }
    }
    
    private func configureLayout() {
        infoImageView.snp.makeConstraints {
            $0.height.width.equalTo(Constants.sizeImage)
            $0.leading.equalToSuperview().offset(CGFloat.baseMargin)
            $0.top.bottom.equalToSuperview().inset(CGFloat.compactMargin).priority(.high)
        }
        titleTextLabel.snp.makeConstraints {
            $0.leading.equalTo(infoImageView.snp.trailing).offset(CGFloat.smallMargin)
            $0.centerY.equalToSuperview()
        }
        countTextLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints {
            $0.height.width.equalTo(Constants.sizeImage)
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin)
            $0.leading.equalTo(countTextLabel.snp.trailing).offset(CGFloat.smallMargin)
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - Configurable

extension SettingsTableViewCell: Configurable {
    
    enum FieldType {
        case number
        case timer
    }
    
    struct Model {
        let icon: UIImage
        let titleText: String
        let countText: String
        let maxValue: Int
        let fieldType: FieldType
    }
    
    func configure(with model: Model) {
        infoImageView.image = model.icon
        titleTextLabel.text = model.titleText
        countTextLabel.text = model.countText
    }
}
