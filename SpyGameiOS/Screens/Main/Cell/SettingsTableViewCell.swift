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
    static let selectedAlpha = 0.3
    static let normalAlpha: CGFloat = 1
    static let animateDuration = 0.1
    static let separatorHeight: CGFloat = 0.5
}

final class SettingsTableViewCell: UITableViewCell {
    
    // UI
    private lazy var titleTextLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textColor = Asset.mainTextColor.color
        return label
    }()
    private lazy var countTextLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.titleFont
        label.textColor = Asset.mainTextColor.color
        return label
    }()
    private lazy var infoImageView = UIImageView()
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.arrowRightImage.image
        return imageView
    }()
    private lazy var separator: UIView = {
       let separator = UIView()
        separator.backgroundColor = .gray
        return separator
    }()
    
    // Public property
    public static var identifier: String { "SettingsTableViewCell" }
    public var separatorHidden: Bool {
        set {
            separator.isHidden = newValue
        }
        get {
            return separator.isHidden
        }
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
        backgroundColor = Asset.mainBackgroundColor.color
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startAnimation(alpha: Constants.selectedAlpha)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        startAnimation(alpha: Constants.normalAlpha)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        startAnimation(alpha: Constants.normalAlpha)
    }
    
    // MARK: - Private
    
    private func addViews() {
        addSubviews(
            infoImageView,
            titleTextLabel,
            countTextLabel,
            arrowImageView,
            separator
        )
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
        separator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Constants.separatorHeight)
            $0.leading.equalToSuperview().inset(CGFloat.extraLargeMargin)
            $0.trailing.equalToSuperview()
        }
    }
    
    private func startAnimation(alpha: CGFloat) {
        UIView.animate(
            withDuration: Constants.animateDuration,
            delay: 0,
            options: UIView.AnimationOptions()
        ) {
            self.alpha = alpha
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
        infoImageView.image = model.icon.withTintColor(Asset.mainTextColor.color)
        titleTextLabel.text = model.titleText
        countTextLabel.text = model.countText
    }
}
