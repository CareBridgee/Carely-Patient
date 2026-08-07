//
//  NurseOfferResponseDTO.swift
//  Carely
//
//  Created by Mohamed Ayman on 03/08/2026.
//

import Foundation

struct NurseOfferResponseDTO: Decodable {
    let id: String
    let serviceRequestId: String
    let nurseId: String
    let proposedPrice: Double
    let proposedDate: String
    let proposedTime: String
    let message: String?
    let status: String
    let createdAt: String
    let updatedAt: String
}

struct ReservationEventDTO: Decodable {
    let type: String
    let reservationId: String?
    let data: NurseOfferResponseDTO?
}

struct OfferReferenceDTO: Decodable {
    let offerId: String
}
