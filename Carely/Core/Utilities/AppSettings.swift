//
//  file.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//
import Foundation

protocol AppSettingsProtocol {
    var hasSeenOnboarding: Bool { get set }
}

final class AppSettings: AppSettingsProtocol {
    static let shared = AppSettings()
    
    private let defaults = UserDefaults.standard
    private let hasSeenOnboardingKey = "hasSeenOnboarding"
    
    var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: hasSeenOnboardingKey) }
        set { defaults.set(newValue, forKey: hasSeenOnboardingKey) }
    }
    
    private init() {} 
}
