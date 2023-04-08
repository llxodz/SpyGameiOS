//
//  CategoryViewCell.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 22.01.2023.
//

import UIKit
import SnapKit
import Combine

private enum Constants {
    static let switchScale: CGFloat = 0.9
    static let nameFont = FontFamily.Montserrat.medium.font(size: 16)
}

final class CategoryViewCell: UITableViewCell {
    
    // UI
    private let name = UILabel()
    let switchCase = UISwitch()
    
    // Public property
    static var identifier: String { "CategoryViewCell" }
    var cancellables = Set<AnyCancellable>()
    let isOn = PassthroughSubject<Bool, Never>()
    
    
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
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    // MARK: - Actions
    
    private func configureAction() {
        switchCase.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func onSwitchValueChanged(_ switch: UISwitch) {
        isOn.send(`switch`.isOn)
    }
    
    // MARK: - Private
    
    private func addViews() {
        contentView.addSubviews(name, switchCase)
    }
    
    private func configureLayout() {
        name.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CGFloat.baseMargin)
            $0.top.bottom.equalToSuperview().inset(CGFloat.smallMargin)
        }
        switchCase.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configureAppearance() {
        backgroundColor = Asset.Colors.mainBackgroundColor.color
        name.font = Constants.nameFont
        name.textColor = Asset.Colors.mainTextColor.color
        switchCase.transform = CGAffineTransform(scaleX: Constants.switchScale, y: Constants.switchScale)
    }
}

// MARK: - Configurable

extension CategoryViewCell: Configurable {
    
    func configure(with model: GameCategory) {
        name.text = model.data.name
        switchCase.isOn = model.selected
    }
}

