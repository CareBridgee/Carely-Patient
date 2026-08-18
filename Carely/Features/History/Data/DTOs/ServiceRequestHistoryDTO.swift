//
//  ServiceRequestHistoryDTO.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
 
/// A single item as returned by GET /api/v1/service-requests/confirmed.
struct ServiceRequestHistoryDTO: Decodable {
    let serviceRequestId: String
    let profileId: String?
    let nurse: NurseDetailsDTO?
    let serviceTypeId: String?
    let serviceName: String?
    let serviceDescription: String?
    let preferredDate: String?
    let preferredTime: FlexibleTimeDTO?
    let status: String?
    let createdAt: String?
}
 
/// Full detail as returned by GET /api/v1/service-requests/{id}.
struct ServiceRequestDetailDTO: Decodable {
    let serviceRequestId: String
    let profileId: String?
    let profile: ProfileRefDTO?
    let serviceType: ServiceTypeRefDTO?
    let serviceDescription: String?
    let preferredDate: String?
    let preferredTime: FlexibleTimeDTO?
    let durationMinutes: Int?
    let status: String?
    let nurse: NurseDetailsDTO?
    let latitude: Double?
    let longitude: Double?
    let distanceKm: Double?
    let createdAt: String?
    let updatedAt: String?
    let offers: [RequestDetailOfferDTO]?
}

struct ProfileRefDTO: Decodable {
    let id: String?
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    let profileImageUrl: String?
}

struct ServiceTypeRefDTO: Decodable {
    let id: String?
    let name: String?
    let basePrice: Double?
    let estimatedDurationMinutes: Int?
}

struct RequestDetailOfferDTO: Decodable {
    let id: String?
    let serviceRequestId: String?
    let nurse: NurseDetailsDTO?
    let proposedPrice: Double?
    let proposedDate: String?
    let proposedTime: FlexibleTimeDTO?
    let message: String?
    let status: String?
    let distanceKm: Double?
    let serviceTypeName: String?
    let estimatedDurationMinutes: Int?
    let createdAt: String?
    let updatedAt: String?
}
 
