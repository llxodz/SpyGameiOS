//
//  CategoryTableViewCell.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 22.01.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let switchScale: CGFloat = 0.9
    static let nameFont = FontFamily.Montserrat.medium.font(size: 16)
}

final class CategoryTableViewCell: UITableViewCell {
    
    // UI
    private let name = UILabel()
    private let switchCase = UISwitch()
    
    // Public property
    public static var identifier: String { "CategoryTableViewCell" }
    public var updateSelected: (Bool) -> Void = { _ in }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        configureLayout()
        configureAppearance()
        configureAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addViews() {
        contentView.addSubviews(name, switchCase)
    }
    
    private func configureLayout() {
        switchCase.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin)
            $0.centerY.equalToSuperview()
        }
        name.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CGFloat.baseMargin)
            $0.top.bottom.equalToSuperview().inset(CGFloat.smallMargin)
        }
    }
    
    private func configureAppearance() {
        backgroundColor = Asset.mainBackgroundColor.color
        switchCase.transform = CGAffineTransform(scaleX: Constants.switchScale, y: Constants.switchScale)
        name.font = Constants.nameFont
        name.textColor = Asset.mainTextColor.color
        
    }
    
    private func configureAction() {
        switchCase.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func onSwitchValueChanged(_ switch: UISwitch) {
        updateSelected(`switch`.isOn)
    }
}

// MARK: - Configurable

extension CategoryTableViewCell: Configurable {
    
    func configure(with model: Category) {
        name.text = model.name
        switchCase.isOn = model.selected
    }
}

