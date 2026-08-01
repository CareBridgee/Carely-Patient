//
//  ServiceRequestPatient.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 01/08/2026.
//


import Foundation

struct ServiceRequestPatient: Identifiable, Equatable {
    let id: String
    let firstName: String
    let lastName: String
    let relationship: String
    let isPrimary: Bool

    var displayName: String {
        relationship.caseInsensitiveCompare("self") == .orderedSame ? "Myself" : "\(firstName) \(lastName)"
    }
}

struct ServiceRequestAddress: Equatable {
    let id: String
    let profileId: String
    let country: String
    let city: String
    let area: String
    let street: String
    let buildingNumber: String
    let apartmentNumber: String
    let latitude: Double
    let longitude: Double
}

struct NearbyNurseInfo: Equatable {
    let nurseId: String
    let latitude: Double
    let longitude: Double
    let distanceKm: Double
}

struct ServiceRequestResult: Equatable {
    let serviceRequestId: String
    let profileId: String
    let serviceTypeId: String
    let status: String
    let latitude: Double
    let longitude: Double
    let nearbyNurses: [NearbyNurseInfo]
}

enum ServiceRequestValidationError: LocalizedError {
    case missingAddress
    var errorDescription: String? {
        switch self {
        case .missingAddress: return "Please add an address before submitting your request."
        }
    }
}
extension ServiceRequestAddress {
    var asHomeAddress: HomeAddress {
        HomeAddress(
            country: country, city: city, area: area, streetName: street,
            building: buildingNumber, apartment: apartmentNumber,
            latitude: latitude, longitude: longitude
        )
    }
}
