//
//  PatientProfile.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation

struct PatientProfile: Equatable {
    let name: String
    let role: String
    let avatarIconName: String
    let appVersionText: String
}

enum ProfileMenuItem: String, Identifiable {
    case personalInfo
    case healthProfile
    case familyMembers
    case addresses
    case payment
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .personalInfo: return "Personal Info"
        case .healthProfile: return "Health Profile"
        case .familyMembers: return "Family Members"
        case .addresses: return "Addresses"
        case .payment: return "Payment"
        case .settings: return "Settings"
        }
    }

    var iconName: String {
        switch self {
        case .personalInfo: return "person.fill"
        case .healthProfile: return "shield.fill"
        case .familyMembers: return "person.3.fill"
        case .addresses: return "mappin.circle.fill"
        case .payment: return "creditcard.fill"
        case .settings: return "gearshape.fill"
        }
    }

    /// Only `healthProfile` gets the filled brand-color treatment in the design;
    /// every other row uses a neutral icon tile.
    var isHighlighted: Bool { self == .healthProfile }
}

struct ProfileMenuRowData: Identifiable {
    let item: ProfileMenuItem
    let subtitle: String

    var id: String { item.id }
}
