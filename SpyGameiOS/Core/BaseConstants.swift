//
//  CGFloat+Constants.swift
//  SpyGameiOS
//
//  Created by Andrew on 25.01.2022.
//

import UIKit

// MARK: - URL

extension String {
    /// Базовый URL бека, откуда получаем данные
    public static let spyBaseURL: String = "http://localhost:3000"
}

// MARK: - Margin

extension CGFloat {
    /// Отступ от краев и между элементами (4 pt)
    public static let tinyMargin: CGFloat = 4
    /// Отступ от краев и между элементами (8 pt)
    public static let smallMargin: CGFloat = 8
    /// Отступ от краев и между элементами (12 pt)
    public static let compactMargin: CGFloat = 12
    /// Отступ от краев и между элементами (16 pt)
    public static let baseMargin: CGFloat = 16
    /// Отступ от краев и между элементами (24 pt)
    public static let largeMargin: CGFloat = 24
    /// Отступ от краев и между элементами (32 pt)
    public static let extraLargeMargin: CGFloat = 32
}

// MARK: - Spaces

extension CGFloat {
    /// Пустое пространство между элементами (2 pt)
    public static let minimalSpace: CGFloat = 2
    /// Пустое пространство между элементами (4 pt)
    public static let tinySpace: CGFloat = 4
    /// Пустое пространство между элементами (8 pt)
    public static let smallSpace: CGFloat = 8
    /// Пустое пространство между элементами (12 pt)
    public static let compactSpace: CGFloat = 12
    /// Пустое пространство между элементами (16 pt)
    public static let baseSpace: CGFloat = 16
    /// Пустое пространство между элементами (20 pt)
    public static let mediumSpace: CGFloat = 20
    /// Пустое пространство между элементами (24 pt)
    public static let largeSpace: CGFloat = 24
    /// Пустое пространство между элементами (32 pt)
    public static let extraLargeSpace: CGFloat = 32
}

// MARK: - Radius

extension CGFloat {
    /// Радиус закругления элементов (4 pt)
    public static let tinyRadius: CGFloat = 4
    /// Радиус закругления элементов (6 pt)
    public static let smallRadius: CGFloat = 6
    /// Радиус закругления элементов (8 pt)
    public static let compactRadius: CGFloat = 8
    /// Радиус закругления элементов (12 pt)
    public static let baseRadius: CGFloat = 12
    /// Радиус закругления элементов (16 pt)
    public static let mediumRadius: CGFloat = 16
    /// Радиус закругления элементов (20 pt)
    public static let largeRadius: CGFloat = 20
}
