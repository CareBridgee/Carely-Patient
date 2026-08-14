//
//  PatientProfile.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation

// MARK: - PatientProfile (mapped from FullProfileResponseDTO)

struct PatientProfile: Equatable {
    let id: String
    let firstName: String
    let lastName: String
    let relationship: String?
    let gender: String?
    let dateOfBirth: String?
    let bloodType: String?
    let height: Double?
    let weight: Double?
    let mobilityStatus: String?
    let mobilityNotes: String?
    let previousSurgeries: String?
    let previousHospitalizations: String?
    let profileImageUrl: String?
    let isPrimary: Bool

    // MARK: Computed helpers for the UI

    var displayName: String {
        let full = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        return full.isEmpty ? "My Profile" : full
    }

    var roleText: String {
        guard let r = relationship, !r.isEmpty else { return "Primary User" }
        return r.capitalized
    }

    /// Legacy accessor kept for compatibility.
    var name: String { displayName }
    var role: String { roleText }
    var avatarIconName: String { "person.fill" }
    var appVersionText: String { "Carely" }
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
