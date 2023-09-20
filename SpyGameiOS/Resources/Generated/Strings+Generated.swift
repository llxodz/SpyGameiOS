// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Spy Game
  internal static let spyGameiOS = L10n.tr("Localizable", "SpyGameiOS", fallback: #"Spy Game"#)
  internal enum CardView {
    /// You're local. Your task is to figure out the spy. Ask questions to other players to figure out the spy
    internal static let commonPlayerDescription = L10n.tr("Localizable", "CardView.commonPlayerDescription", fallback: #"You're local. Your task is to figure out the spy. Ask questions to other players to figure out the spy"#)
    /// Try to understand about what talk about
    internal static let spyDescription = L10n.tr("Localizable", "CardView.spyDescription", fallback: #"Try to understand about what talk about"#)
    /// You're a spy
    internal static let spyName = L10n.tr("Localizable", "CardView.spyName", fallback: #"You're a spy"#)
    /// Tap here to view your role
    internal static let startDescription = L10n.tr("Localizable", "CardView.startDescription", fallback: #"Tap here to view your role"#)
    /// Who are you?
    internal static let startName = L10n.tr("Localizable", "CardView.startName", fallback: #"Who are you?"#)
  }
  internal enum CategoriesTableViewCell {
    /// Categories
    internal static let categories = L10n.tr("Localizable", "CategoriesTableViewCell.Categories", fallback: #"Categories"#)
    /// Select all
    internal static let selectAll = L10n.tr("Localizable", "CategoriesTableViewCell.SelectAll", fallback: #"Select all"#)
  }
  internal enum FooterView {
    /// Start game
    internal static let startGame = L10n.tr("Localizable", "FooterView.StartGame", fallback: #"Start game"#)
  }
  internal enum Notification {
    /// It's time to find out who was the spy...
    internal static let description = L10n.tr("Localizable", "Notification.description", fallback: #"It's time to find out who was the spy..."#)
    /// The game is over!
    internal static let title = L10n.tr("Localizable", "Notification.title", fallback: #"The game is over!"#)
  }
  internal enum SettingsCell {
    /// min
    internal static let minute = L10n.tr("Localizable", "SettingsCell.Minute", fallback: #"min"#)
    /// Players
    internal static let players = L10n.tr("Localizable", "SettingsCell.Players", fallback: #"Players"#)
    /// Spys
    internal static let spys = L10n.tr("Localizable", "SettingsCell.Spys", fallback: #"Spys"#)
    /// Timer
    internal static let timer = L10n.tr("Localizable", "SettingsCell.Timer", fallback: #"Timer"#)
  }
  internal enum SettingsViewController {
    /// Refresh
    internal static let refresh = L10n.tr("Localizable", "SettingsViewController.Refresh", fallback: #"Refresh"#)
    /// Save
    internal static let save = L10n.tr("Localizable", "SettingsViewController.Save", fallback: #"Save"#)
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
