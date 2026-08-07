//
//  BasicHealthInfoRequestDTO.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 28/07/2026.
//

import Foundation

// MARK: - Profile Update DTO (PUT /profiles/{id})
struct UpdateProfileRequestDTO: Encodable {
    var height: Double?
    var weight: Double?
    var bloodType: String?
    
    // Mobility Fields
    var mobilityStatus: String?
    var mobilityNotes: String?
    
    // Medical History Fields
    var previousSurgeries: String?
    var previousHospitalizations: String?
}

// MARK: - Sub-resource POST DTOs
struct MedicalConditionRequestDTO: Encodable {
    let conditions: [String]
    let otherDiseases: String
}

struct AllergyRequestDTO: Encodable {
    let drugAllergies: [String]
    let foodAllergies: [String]
    let otherAllergiesNote: String
}

struct MedicationRequestDTO: Encodable {
    let medications: [String]
}

struct MedicalHistoryRequestDTO: Encodable {
    let previousSurgeries: String?
    let previousHospitalizations: String?
}
struct MobilityStatusRequestDTO: Encodable {
    var mobilityStatus: String?
    var mobilityNotes: String?
}
struct EmergencyContactRequestDTO: Encodable {
    let contactName: String 
    let phoneNumber: String
    let relationship: String
}
struct AddressRequestDTO: Encodable {
    let country: String
    let city: String
    let area: String
    let street: String
    let buildingNumber: String
    let apartmentNumber: String
    let latitude: Double
    let longitude: Double
}
