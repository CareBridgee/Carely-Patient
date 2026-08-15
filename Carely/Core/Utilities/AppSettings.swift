import Foundation
import SwiftUI

enum AppAppearance: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    var id: String { rawValue }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

protocol AppSettingsProtocol: AnyObject {
    var hasSeenOnboarding: Bool { get set }
    var appearance: AppAppearance { get set }
}

final class AppSettings: AppSettingsProtocol {
    static let shared = AppSettings()
    
    private let defaults = UserDefaults.standard
    private let hasSeenOnboardingKey = "hasSeenOnboarding"
    private let appearanceKey = "app_appearance"
    
    var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: hasSeenOnboardingKey) }
        set { defaults.set(newValue, forKey: hasSeenOnboardingKey) }
    }
    
    var appearance: AppAppearance {
        get {
            guard let raw = defaults.string(forKey: appearanceKey),
                  let val = AppAppearance(rawValue: raw) else {
                return .system
            }
            return val
        }
        set {
            defaults.set(newValue.rawValue, forKey: appearanceKey)
        }
    }
    
    private init() {} 
}
