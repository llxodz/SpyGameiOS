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
  internal enum FooterView {
    /// Start game
    internal static let startGame = L10n.tr("Localizable", "FooterView.StartGame", fallback: #"Start game"#)
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
    /// OK
    internal static let errorAccept = L10n.tr("Localizable", "SettingsViewController.ErrorAccept", fallback: #"OK"#)
    /// Please, input correct count
    internal static let errorDescription = L10n.tr("Localizable", "SettingsViewController.ErrorDescription", fallback: #"Please, input correct count"#)
    /// Error
    internal static let errorTitle = L10n.tr("Localizable", "SettingsViewController.ErrorTitle", fallback: #"Error"#)
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
