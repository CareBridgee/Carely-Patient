//
//  ProfileResponseDTO.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 01/08/2026.
//


import Foundation

struct ProfileResponseDTO: Decodable {
    let id: String
    let userId: String
    let relationship: String?
    let firstName: String
    let lastName: String
    let isPrimary: Bool
    let isDeleted: Bool
    let profileImageUrl: String?
}

struct AddressResponseDTO: Decodable {
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

struct ServiceRequestBodyDTO: Encodable {
    let profileId: String
    let serviceTypeId: String
    let latitude: Double
    let longitude: Double
    let preferredDate: String
    let preferredTime : String
    let serviceDescription: String
    let paymentType: String
  
}

struct NearbyNurseDTO: Decodable {
    let nurseId: String
    let latitude: Double
    let longitude: Double
    let distanceKm: Double
}

struct ServiceRequestResponseDTO: Decodable {
    let serviceRequestId: String
    let profileId: String
    let serviceTypeId: String
    let status: String
    let latitude: Double
    let longitude: Double
    let nearbyNurses: [NearbyNurseDTO]
}
