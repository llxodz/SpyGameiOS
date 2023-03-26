//
//  MainViewController.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 14.08.2022.
//

import UIKit
import SnapKit
import Combine

private enum Constants {
    static let cellRowHeight: CGFloat = 50
    static let headerHeight: CGFloat = 44
    static let startButtonHeight: CGFloat = 56
    static let indicatorSize: CGFloat = 44
    static let startButtonFont: UIFont = FontFamily.Montserrat.bold.font(size: 16)
}

class MainViewController: BaseViewController {
    
    // Dependencies
    private let viewModel: MainViewModel

    // UI
    private let tableView = UITableView()
    private let headerView = HeaderMainView()
    private let startButton = TappableButton()
    private let indicator = UIActivityIndicatorView(style: .large)
    
    // Private property
    private let clickedOnCell = PassthroughSubject<CellType?, Never>()
    private let clickedStart = PassthroughSubject<Void, Never>()
    private let viewDidLoadEvent = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        addViews()
        configureLayout()
        configureTableView()
        configureAppearance()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        binding()
        configureActions()
        viewDidLoadEvent.send()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - Binding & Actions
    
    private func binding() {
        let output = viewModel.transform(input: MainViewModel.Input(
            clickedOnCell: clickedOnCell.eraseToAnyPublisher(),
            clickedStart: clickedStart.eraseToAnyPublisher(),
            viewDidLoad: viewDidLoadEvent.eraseToAnyPublisher()
        ))
        output.availabilityStart
            .sink { enableButton in
                print("log: enableButton \(enableButton)")
            }
            .store(in: &cancellables)
        output.categoriesState
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    // TODO: - Show skeleton
                    self.tableView.isHidden = true
                    self.indicator.startAnimating()
                case .failed:
                    // TODO: - Show reload button
                    self.tableView.isHidden = true
                    self.indicator.stopAnimating()
                case .success(_):
                    // TODO: - Remove skeleton
                    self.indicator.stopAnimating()
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureActions() {
        startButton.enableTapping { [weak self] in
            self?.clickedStart.send()
        }
    }
    
    // MARK: - Private
    
    private func addViews() {
        view.addSubviews(headerView, tableView, startButton, indicator)
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
        indicator.snp.makeConstraints {
            $0.height.width.equalTo(Constants.indicatorSize)
            $0.center.equalToSuperview()
        }
    }
    
    private func configureAppearance() {
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0.001, height: 0))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0.001, height: 0))
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.backgroundColor = Asset.mainBackgroundColor.color
        // Start Button
        startButton.layer.cornerRadius = .baseRadius
        startButton.setTitle(L10n.FooterView.startGame, for: .normal)
        startButton.titleLabel?.font = Constants.startButtonFont
        startButton.setTitleColor(Asset.mainTextColor.color, for: .normal)
        startButton.backgroundColor = Asset.buttonBackgroundColor.color
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false
        tableView.register(SettingsViewCell.self, forCellReuseIdentifier: SettingsViewCell.identifier)
        tableView.register(CategoriesViewCell.self, forCellReuseIdentifier: CategoriesViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.cellRowHeight
    }
}

// MARK: - Extensions UITableView

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = CellType(rawValue: indexPath.row)
        switch type {
        case .playes, .spies, .timer:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingsViewCell.identifier,
                for: indexPath
            ) as? SettingsViewCell else { return UITableViewCell() }
            cell.selectedBackgroundView = UIView.clearView
            cell.configure(with: viewModel.settingCellModel(for: type))
            cell.separatorHidden = indexPath.row >= viewModel.cells.count - 1
            return cell
            
        case .categories:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CategoriesViewCell.identifier,
                for: indexPath
            ) as? CategoriesViewCell else { return UITableViewCell() }
            cell.selectedBackgroundView = UIView.clearView
            cell.configure(with: viewModel.categories)
            return cell
            
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickedOnCell.send(CellType(rawValue: indexPath.row))
    }
}
