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
    static var clearView: UIView {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

class MainViewController: BaseViewController {
    
    // UI
    private lazy var tableView = UITableView()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Private
    
    private func addViews() {
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func configureAppearance() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0.001, height: 0))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0.001, height: 0))
        tableView.separatorInset = UIEdgeInsets(top: 0, left: .baseMargin, bottom: 0, right: 0)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.cellRowHeight
    }
}

// MARK: - Extensions UITableView

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.identifier,
            for: indexPath
        ) as? SettingsTableViewCell else { return UITableViewCell() }
        cell.selectedBackgroundView = Constants.clearView
        if let type = SettingsCellType(rawValue: indexPath.row) {
            cell.configure(with: type.cellModel())
        }
        return cell
    }
}
