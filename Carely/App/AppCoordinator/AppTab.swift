//
//  AppTab.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//

import Foundation
 
// MARK: - AppTab
 
enum AppTab: CaseIterable {
    case home
    case services
    case history
    case ai
    case profile
}
 
// MARK: - Display Metadata
 
extension AppTab {
    var title: String {
        switch self {
        case .home: return "Home"
        case .services: return "Services"
        case .history: return "History"
        case .ai: return "AI Assistant"
        case .profile: return "Profile"
        }
    }
 
    var iconName: String {
        switch self {
        case .home: return "house.fill"
        case .services: return "stethoscope"
        case .history: return "calendar.badge.clock"
        case .ai: return "sparkles"
        case .profile: return "person.fill"
        }
    }
}
 
