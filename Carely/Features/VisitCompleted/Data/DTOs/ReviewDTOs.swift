//
//  ReviewDTOs.swift
//  Carely
//
//  Created by Mona Zarea on 15/08/2026.
//

import Foundation

struct CreateReviewRequestDTO: Encodable {
    let serviceRequestId: String
    let rating: Int
    let reviewText: String
    let isAnonymous: Bool
}

struct ReviewResponseDTO: Decodable {
    let id: String
    let serviceRequestId: String
    let profileId: String?
    let nurseId: String?
    let rating: Int
    let reviewText: String?
    let isAnonymous: Bool
    let createdAt: String?
    let updatedAt: String?
}
