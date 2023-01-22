//
//  CategoriesTableViewCell.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 22.01.2023.
//

import UIKit
import SnapKit

private enum Constants {
    static let switchScale: CGFloat = 0.8
    static let titleFont = FontFamily.Montserrat.semiBold.font(size: 20)
    static let selectAllFont = FontFamily.Montserrat.regular.font(size: 16)
}

final class CategoriesTableViewCell: UITableViewCell {
    
    // UI
    private let title = UILabel()
    private let selectAllLabel = UILabel()
    private let switchAll = UISwitch()
    private let tableView = AutoTableView()
    
    // Private property
    private var categoties: [Category] = []
    
    // Public property
    public static var identifier: String { "CategoriesTableViewCell" }
    
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
        contentView.addSubviews(title, selectAllLabel, switchAll, tableView)
    }
    
    private func configureLayout() {
        switchAll.snp.makeConstraints {
            $0.leading.equalTo(selectAllLabel.snp.trailing).offset(CGFloat.smallSpace)
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin)
            $0.top.equalToSuperview().inset(CGFloat.compactMargin)
        }
        title.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CGFloat.baseMargin)
            $0.centerY.equalTo(switchAll.snp.centerY)
        }
        selectAllLabel.snp.makeConstraints {
            $0.centerY.equalTo(switchAll.snp.centerY)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(switchAll.snp.bottom).offset(CGFloat.compactSpace)
            $0.leading.equalToSuperview().inset(CGFloat.baseMargin)
            $0.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureAppearance() {
        backgroundColor = Asset.mainBackgroundColor.color
        switchAll.transform = CGAffineTransform(scaleX: Constants.switchScale, y: Constants.switchScale)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.isMultipleTouchEnabled = false
        tableView.backgroundColor = .clear
        title.text = L10n.CategoriesTableViewCell.categories
        title.font = Constants.titleFont
        title.textColor = Asset.mainTextColor.color
        selectAllLabel.text = L10n.CategoriesTableViewCell.selectAll
        selectAllLabel.font = Constants.selectAllFont
        selectAllLabel.textColor = Asset.mainTextColor.color
    }
}

// MARK: - Configurable

extension CategoriesTableViewCell: Configurable {
    
    func configure(with model: [Category]) {
        self.categoties = model
    }
}

// MARK: - TableView

extension CategoriesTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryTableViewCell.identifier,
            for: indexPath
        ) as? CategoryTableViewCell else { return UITableViewCell() }
        cell.selectedBackgroundView = UIView.clearView
        if let model = categoties[safe: indexPath.row] {
            cell.configure(with: model)
        }
        return cell
    }
}
