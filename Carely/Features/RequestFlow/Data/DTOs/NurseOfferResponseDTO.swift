//
//  NurseOfferResponseDTO.swift
//  Carely
//
//  Created by Mohamed Ayman on 03/08/2026.
//

import Foundation

struct NurseOfferResponseDTO: Decodable {
    let id: String
    let serviceRequestId: String?
    let nurse: NurseDetailsDTO
    let proposedPrice: Double
    let proposedDate: String?
    let proposedTime: String?
    let message: String?
    let status: String?
    let distanceKm: Double?
    let serviceTypeName: String?
    let estimatedDurationMinutes: Int?
    let createdAt: String?
    let updatedAt: String?
}

struct NurseDetailsDTO: Decodable {
    let id: String
    let firstName: String?
    let lastName: String?
    let profileImageUrl: String?
    let ratingAvg: Double?
    let totalReviews: Int?
}

struct ReservationEventDTO: Decodable {
    let type: String
    let reservationId: String?
    let data: NurseOfferResponseDTO?
}

struct OfferReferenceDTO: Decodable {
    let offerId: String
}
