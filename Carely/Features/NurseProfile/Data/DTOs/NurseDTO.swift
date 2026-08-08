//
//  NurseDTO.swift
//  Carely
//
//  Created by Mina on 08/08/2026.
//

import Foundation

struct NurseDTO: Decodable {
    let id: String
    let userId: String
    let firstName: String
    let lastName: String?
    let phoneNumber: String
    let profileImageUrl: String?
    let nationalId: String?
    let nationalIdFrontUrl: String?
    let nationalIdBackUrl: String?
    let licenseImageUrl: String?
    let professionalCertificateUrl: String?
    let specialization: String
    let yearsOfExperience: Int
    let bio: String?
    let ratingAvg: Double
    let totalReviews: Int
    let verificationStatus: String
    let rejectionReason: String?
    let rejectionDetails: String?
    let services: [NurseServiceDTO]
}

struct NurseServiceDTO: Decodable {
    let id: String
    let serviceTypeId: String
    let serviceName: String
    let serviceDescription: String?
    let basePrice: Double
    let isActive: Bool
}
