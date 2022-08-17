//
//  HeaderMainView.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 17.08.2022.
//

import UIKit
import SnapKit

private enum Constants {
    static let titleFont = FontFamily.Montserrat.bold.font(size: 16)
    static let heightSeparator: CGFloat = 0.5
}

class HeaderMainView: UIView {
    
    // UI
    private lazy var backgroundView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        configureLayout()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addViews() {
        [backgroundView, titleLabel, separatorView].forEach {
            addSubview($0)
        }
    }
    
    private func configureLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        separatorView.snp.makeConstraints {
            $0.height.equalTo(Constants.heightSeparator)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureAppearance() {
        backgroundView.backgroundColor = .white
        
        titleLabel.text = L10n.spyGameiOS
        titleLabel.font = Constants.titleFont
    }
}
