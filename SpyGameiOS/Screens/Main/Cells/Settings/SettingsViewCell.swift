//
//  SettingsViewCell.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 15.08.2022.
//

import UIKit
import SnapKit

private enum Constants {
    static let sizeImage: CGFloat = 24
    static let titleFont = FontFamily.Montserrat.medium.font(size: 16)
    static let separatorHeight: CGFloat = 0.5
}

final class SettingsViewCell: AnimatedPressTableCell {
    
    // Public property
    public static var identifier: String { "SettingsViewCell" }
    public var separatorHidden: Bool {
        set { separator.isHidden = newValue }
        get { return separator.isHidden }
    }
    
    // UI
    private let titleTextLabel = UILabel()
    private let countTextLabel = UILabel()
    private let infoImageView = UIImageView()
    private let arrowImageView = UIImageView()
    private let separator = UIView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
        configureAppearance()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addViews() {
        addSubview(infoImageView)
        addSubview(titleTextLabel)
        addSubview(countTextLabel)
        addSubview(arrowImageView)
        addSubview(separator)
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
    
    private func configureAppearance() {
        backgroundColor = Asset.mainBackgroundColor.color
        // Labels
        titleTextLabel.font = Constants.titleFont
        titleTextLabel.textColor = Asset.mainTextColor.color
        countTextLabel.font = Constants.titleFont
        countTextLabel.textColor = Asset.mainTextColor.color
        // Image
        arrowImageView.image = Asset.arrowRightImage.image
        // Separator
        separator.backgroundColor = .gray
    }
}

// MARK: - Configurable

extension SettingsViewCell: Configurable {
    
    enum FieldType {
        case number
        case timer
    }
    
    struct Model {
        let icon: UIImage
        let titleText: String
        var countText: String
        let maxValue: Int
        let minValue: Int
        let fieldType: FieldType
    }
    
    func configure(with model: Model) {
        infoImageView.image = model.icon.withTintColor(Asset.mainTextColor.color)
        titleTextLabel.text = model.titleText
        
        switch model.fieldType {
        case .number: countTextLabel.text = String(model.countText)
        case .timer: countTextLabel.text = "\(model.countText) \(L10n.SettingsCell.minute)"
        }
    }
}
