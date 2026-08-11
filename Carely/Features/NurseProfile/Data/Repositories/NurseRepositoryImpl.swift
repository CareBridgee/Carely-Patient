//
//  NurseRepositoryImpl.swift
//  Carely
//
//  Created by Mina on 08/08/2026.
//

import Foundation

final class NurseRepositoryImpl: NurseRepositoryProtocol {
    private let service: NurseServiceProtocol

    init(service: NurseServiceProtocol) {
        self.service = service
    }

    func getNurseProfile(id: String) async throws -> NurseDetails {
        let dto = try await service.getNurse(id: id)
        return map(dto)
    }

    // MARK: - Mapping

    private func map(_ dto: NurseDTO) -> NurseDetails {
        NurseDetails(
            id: dto.id,
            fullName: fullName(from: dto),
            // The API doesn't return a professional title yet; every
            // provider in this app is a nurse, so "RN" is a safe default.
            title: "RN",
            specialty: dto.specialization.capitalized,
            profileImageUrl: dto.profileImageUrl,
            rating: dto.ratingAvg,
            reviewsCount: dto.totalReviews,
            experienceYears: dto.yearsOfExperience,
            providedServices: dto.services.map { $0.serviceName.capitalized },
            certificates: certificates(from: dto),
            personalApproach: dto.bio ?? ""
        )
    }

    private func fullName(from dto: NurseDTO) -> String {
        let last = dto.lastName?.trimmingCharacters(in: .whitespaces) ?? ""
        return last.isEmpty ? dto.firstName : "\(dto.firstName) \(last)"
    }

    private func certificates(from dto: NurseDTO) -> [NurseDetails.Certificate] {
        var certificates: [NurseDetails.Certificate] = []

        if let licenseUrl = dto.licenseImageUrl {
            certificates.append(.init(name: "Nursing License", imageUrl: licenseUrl))
        }
        if let certUrl = dto.professionalCertificateUrl {
            certificates.append(.init(name: "Professional Certificate", imageUrl: certUrl))
        }
        return certificates
    }
}
