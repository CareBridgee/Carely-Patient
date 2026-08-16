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
    case ai
    case profile
}
 
// MARK: - Display Metadata
 
extension AppTab {
    var title: String {
        switch self {
        case .home: return "Home"
        case .services: return "Services"
        case .ai: return "AI Assistant"
        case .profile: return "Profile"
        }
    }
 
    func iconName(isSelected: Bool) -> String {
        switch self {
        case .home: return isSelected ? "house.fill" : "house"
        case .services: return isSelected ? "stethoscope" : "stethoscope"
        case .ai: return isSelected ? "sparkles" : "sparkles"
        case .profile: return isSelected ? "person.fill" : "person"
        }
    }
}
