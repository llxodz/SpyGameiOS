//
//  CategoriesViewCell.swift
//  SpyGameiOS
//
//  Created by Andrey Firsenko on 22.01.2023.
//

import UIKit
import SnapKit
import Combine

private enum Constants {
    static let switchScale: CGFloat = 0.8
    static let titleFont = FontFamily.Montserrat.semiBold.font(size: 20)
    static let selectAllFont = FontFamily.Montserrat.regular.font(size: 16)
}

final class CategoriesViewCell: UITableViewCell {
    
    // UI
    private let title = UILabel()
    private let selectAllLabel = UILabel()
    private let allSwitch = UISwitch()
    private let tableView = AutoTableView()
    
    // Private property
    private var viewModel: CategoriesViewModel?
    private var cancellables = Set<AnyCancellable>()
    private let switchAll = PassthroughSubject<Bool, Never>()
    private let switchCategory = PassthroughSubject<Category, Never>()
    private var switchAllCategories: AnyPublisher<Bool, Never>?
    private var availabilityStart: CurrentValueSubject<Bool, Never>?
    
    // Public property
    public static var identifier: String { "CategoriesViewCell" }
    
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
        viewModel = nil
        switchAllCategories = nil
        
    }
    
    // MARK: - Binding & Actions
    
    private func binding() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        
        let input = CategoriesViewModel.Input(
            switchAll: switchAll.eraseToAnyPublisher(),
            switchCategory: switchCategory.eraseToAnyPublisher()
        )
        
        let output = viewModel?.transform(input: input)
        output?.switchAll
            .sink { [weak self] isOn in
                self?.allSwitch.setOn(isOn, animated: true)
            }
            .store(in: &cancellables)
        output?.availabilityStart
            .removeDuplicates()
            .sink { [weak self] isAvailability in
                self?.availabilityStart?.send(isAvailability)
            }
            .store(in: &cancellables)
        switchAllCategories = output?.switchAllCategories
    }
    
    private func configureAction() {
        allSwitch.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: .valueChanged)
    }
    
    @objc private func onSwitchValueChanged(_ switch: UISwitch) {
        switchAll.send(`switch`.isOn)
    }
    
    // MARK: - Private
    
    private func addViews() {
        contentView.addSubviews(title, selectAllLabel, allSwitch, tableView)
    }
    
    private func configureLayout() {
        allSwitch.snp.makeConstraints {
            $0.leading.equalTo(selectAllLabel.snp.trailing).offset(CGFloat.smallSpace)
            $0.trailing.equalToSuperview().inset(CGFloat.baseMargin)
            $0.top.equalToSuperview().inset(CGFloat.compactMargin)
        }
        title.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(CGFloat.baseMargin)
            $0.centerY.equalTo(allSwitch.snp.centerY)
        }
        selectAllLabel.snp.makeConstraints {
            $0.centerY.equalTo(allSwitch.snp.centerY)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(allSwitch.snp.bottom).offset(CGFloat.compactSpace)
            $0.leading.equalToSuperview().inset(CGFloat.baseMargin)
            $0.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureAppearance() {
        backgroundColor = Asset.mainBackgroundColor.color
        allSwitch.transform = CGAffineTransform(scaleX: Constants.switchScale, y: Constants.switchScale)
        configureTableView()
        configureLabels()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CategoryViewCell.self, forCellReuseIdentifier: CategoryViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.isMultipleTouchEnabled = false
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
    }
    
    private func configureLabels() {
        title.text = L10n.CategoriesTableViewCell.categories
        title.font = Constants.titleFont
        title.textColor = Asset.mainTextColor.color
        selectAllLabel.text = L10n.CategoriesTableViewCell.selectAll
        selectAllLabel.font = Constants.selectAllFont
        selectAllLabel.textColor = Asset.mainTextColor.color
    }
}

// MARK: - Configurable

extension CategoriesViewCell: Configurable {
    
    struct Model {
        let categories: [Category]
        /// Доступность кнопки старт
        let availabilityStart: CurrentValueSubject<Bool, Never>
    }
    
    func configure(with model: Model) {
        self.availabilityStart = model.availabilityStart
        viewModel = CategoriesViewModel(categories: model.categories)
        binding()
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
}

// MARK: - TableView

extension CategoriesViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.categories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryViewCell.identifier,
            for: indexPath
        ) as? CategoryViewCell else { return UITableViewCell() }
        
        cell.selectedBackgroundView = UIView.clearView
        guard let model = viewModel?.categories[safe: indexPath.row] else { return cell }
       
        cell.configure(with: model)
        cell.isOn
            .sink { [weak self] isOn in
                self?.switchCategory.send(model.withSelected(isOn))
            }
            .store(in: &cell.cancellables)
        switchAllCategories?
            .sink { isOn in
                cell.switchCase.setOn(isOn, animated: true)
            }
            .store(in: &cell.cancellables)
        
        return cell
    }
}
