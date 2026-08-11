//
//  AIPatientRepositoryImpl.swift
//  Carely
//
//  Created by Mohamed Ayman on 08/08/2026.
//

import Foundation

final class AIPatientRepositoryImpl: AIPatientRepositoryProtocol {
    private let serviceRequestService: ServiceRequestServiceProtocol

    init(serviceRequestService: ServiceRequestServiceProtocol) {
        self.serviceRequestService = serviceRequestService
    }

    func getPatients() async throws -> [AIPatient] {
        let profiles = try await serviceRequestService.getProfiles()
        let activeProfiles = profiles.filter { !$0.isDeleted }
        return activeProfiles.map { dto in
            let fullName = "\(dto.firstName) \(dto.lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
            let name = fullName.isEmpty ? "Patient" : fullName
            return AIPatient(
                id: dto.id,
                name: name,
                relation: dto.relationship,
                isSelf: dto.isPrimary
            )
        }
    }
}
