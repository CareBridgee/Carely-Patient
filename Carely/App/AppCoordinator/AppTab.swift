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
    case profile
}
 
// MARK: - Display Metadata
 
extension AppTab {
    var title: String {
        switch self {
        case .home: return "Home"
        case .services: return "Services"
        case .history: return "History"
        case .profile: return "Profile"
        }
    }
 
    func iconName(isSelected: Bool) -> String {
        switch self {
        case .home: return isSelected ? "house.fill" : "house"
        case .services: return isSelected ? "stethoscope" : "stethoscope"
        case .history: return isSelected ? "clock.fill" : "clock"
        case .profile: return isSelected ? "person.fill" : "person"
        }
    }
}
