//
//  MainViewController.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 14.08.2022.
//

import UIKit
import SnapKit

private enum Constants {
    static let cellRowHeight: CGFloat = 50
    static let headerHeight: CGFloat = 44
    static let startButtonHeight: CGFloat = 56
}

class MainViewController: BaseViewController {
    
    // Private property
    // TODO: - Удалить и вынести во viewModel
    private let categories: [Category] = [
        Category(id: 0, name: "В городе", selected: false),
        Category(id: 1, name: "Гей порно", selected: false),
        Category(id: 2, name: "Гавр хуй", selected: false)
    ]
    private let viewModel = MainViewModel()
    
    // UI
    private lazy var tableView = UITableView()
    private lazy var headerView = HeaderMainView()
    private lazy var startButton = StartGameButton()
    
    // MARK: - Init
    
    override init() {
        super.init()
        addViews()
        configureLayout()
        configureTableView()
        configureAppearance()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Private
    
    private func addViews() {
        view.addSubviews(headerView, tableView, startButton)
    }
    
    private func configureLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.headerHeight)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        startButton.snp.makeConstraints {
            $0.height.equalTo(Constants.startButtonHeight)
            $0.leading.trailing.equalToSuperview().inset(CGFloat.baseMargin)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureAppearance() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0.001, height: 0))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0.001, height: 0))
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.backgroundColor = Asset.mainBackgroundColor.color
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        tableView.register(CategoriesViewCell.self, forCellReuseIdentifier: CategoriesViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.cellRowHeight
    }
}

// MARK: - Extensions UITableView

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsCellType.allCases.count + 1 // Последняя ячейка с категориями
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == SettingsCellType.allCases.count {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategoriesViewCell.identifier,
                for: indexPath
            ) as? CategoriesViewCell else { return UITableViewCell() }
            cell.selectedBackgroundView = UIView.clearView
            cell.configure(with: categories)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingsTableViewCell.identifier,
                for: indexPath
            ) as? SettingsTableViewCell else { return UITableViewCell() }
            cell.selectedBackgroundView = UIView.clearView
            if let type = SettingsCellType(rawValue: indexPath.row) {
                cell.configure(with: type.cellModel())
            }
            cell.separatorHidden = indexPath.row >= SettingsCellType.allCases.count - 1
            return cell
        }
    }
}
