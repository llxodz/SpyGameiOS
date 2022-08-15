//
//  SettingsTaleViewCell.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 15.08.2022.
//

import UIKit
import SnapKit

private enum Constants {
    static let normalMargin: CGFloat = 8
    static let horizontalMargin: CGFloat = 16
    static let verticalMargin: CGFloat = 12
    
    static let heightImageView: CGFloat = 24
    static let widthImageView: CGFloat = 24
    
    static let arrowImage = Asset.arrowRightImage.image
    static let playerImage = Asset.playerImage.image
    static let spyImage = Asset.spyImage.image
    static let clockImage = Asset.clockImage.image
    
    static let titleFont = FontFamily.Montserrat.medium.font(size: 16)
}

class SettingsTableViewCell: UITableViewCell {
    
    // Public property
    public static var identifier: String {
        String(describing: self)
    }
    
    // UI
    private lazy var customTextLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textColor = .black
        return label
    }()
    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.arrowImage
        return imageView
    }()
    private lazy var countTextLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textColor = .black
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
        [infoImageView, customTextLabel, arrowImageView, countTextLabel].forEach {
            addSubview($0)
        }
    }
    
    private func configureLayout() {
        infoImageView.snp.makeConstraints {
            $0.height.equalTo(Constants.heightImageView)
            $0.width.equalTo(Constants.widthImageView)
            $0.left.equalTo(Constants.horizontalMargin)
            $0.top.equalTo(Constants.verticalMargin)
            $0.bottom.equalTo(-Constants.verticalMargin)
        }
        
        customTextLabel.snp.makeConstraints {
            $0.left.equalTo(
                Constants.horizontalMargin + Constants.widthImageView + Constants.normalMargin
            )
            $0.top.equalTo(Constants.verticalMargin)
            $0.bottom.equalTo(-Constants.verticalMargin)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.height.equalTo(Constants.heightImageView)
            $0.width.equalTo(Constants.widthImageView)
            $0.right.equalTo(-Constants.horizontalMargin)
            $0.top.equalTo(Constants.verticalMargin)
            $0.bottom.equalTo(-Constants.verticalMargin)
        }
        
        countTextLabel.snp.makeConstraints {
            $0.top.equalTo(Constants.verticalMargin)
            $0.bottom.equalTo(-Constants.verticalMargin)
            $0.right.equalTo(
                -Constants.horizontalMargin - Constants.widthImageView - Constants.normalMargin
            )
        }
    }
}

extension SettingsTableViewCell: Configurable {
    
    struct Model {
        let id: Int
        let title: String
    }
    
    func configure(with model: Model) {
        customTextLabel.text = model.title
        switch model.id {
            case 0:
                infoImageView.image = Constants.playerImage
                countTextLabel.text = "4"
            case 1:
                infoImageView.image = Constants.spyImage
                countTextLabel.text = "1"
            case 2:
                infoImageView.image = Constants.clockImage
                countTextLabel.text = "1:00"
            default: infoImageView.image = UIImage()
        }
    }
}
