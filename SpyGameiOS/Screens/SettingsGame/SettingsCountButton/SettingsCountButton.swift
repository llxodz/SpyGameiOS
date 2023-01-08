//
//  SettingsCountButton.swift
//  SpyGameiOS
//
//  Created by Ilya Gavrilov on 17.12.2022.
//

import UIKit
import SnapKit

enum ImageInButton {
    case plusImage, minusImage
}

private enum Constants {
    static let heightButton: CGFloat = 16
    
    static let selectedAlpha: CGFloat = 0.5
    static let normalAlpha: CGFloat = 1
}

final class SettingsCountButton: UIView, Tappable {
    
    /// External properties
    private var image: ImageInButton = .plusImage
    
    /// UI
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Asset.buttonStartColor.color
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat.smallRadius
        return view
    }()
    private lazy var imageButton: UIImageView = UIImageView()
    
    // MARK: - Init
    
    init(image: ImageInButton) {
        super.init(frame: .zero)
        self.image = image
        addViews()
        configureLayout()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateTapButton(alpha: Constants.selectedAlpha)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateTapButton(alpha: Constants.normalAlpha)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        animateTapButton(alpha: Constants.normalAlpha)
    }
    
    // MARK: - Private
    
    private func addViews() {
        addSubviews(backgroundView, imageButton)
    }
    
    private func configureLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        imageButton.snp.makeConstraints {
            $0.center.equalTo(backgroundView.snp.center)
            $0.height.width.equalTo(Constants.heightButton)
        }
    }
    
    private func configureAppearance() {
        switch image {
        case .plusImage: imageButton.image = Asset.plusImage.image
        case .minusImage: imageButton.image = Asset.minusImage.image
        }
    }
}