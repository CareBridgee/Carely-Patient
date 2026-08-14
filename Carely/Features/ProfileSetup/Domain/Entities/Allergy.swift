//
//  Allergy.swift
//  Carely
//

import Foundation

enum AllergyType: String, Codable, CaseIterable, Equatable, Hashable {
    case drug = "DRUG"
    case food = "FOOD"
    case other = "OTHER"

    var displayName: String {
        switch self {
        case .drug:  return "Drug Allergies"
        case .food:  return "Food Allergies"
        case .other: return "Other Allergies"
        }
    }
}

struct Allergy: Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let type: AllergyType
    let source: String?
}
