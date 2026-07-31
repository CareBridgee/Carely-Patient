//
//  CareRequestRepositoryImpl.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//

import Foundation

final class CareRequestRepositoryImpl: CareRequestRepositoryProtocol {
    private let simulatedDelayNanoseconds: UInt64 = 600_000_000
    private let serviceTypeService: ServiceTypeServiceProtocol

    init(serviceTypeService: ServiceTypeServiceProtocol) {
        self.serviceTypeService = serviceTypeService
    }

    func fetchAvailableServices() async throws -> [CareService] {
        let serviceTypes = try await serviceTypeService.getServiceTypes()
        return serviceTypes.map { CareService(serviceType: $0) }
    }

    func fetchSavedAddress() async throws -> PatientAddress? {
        // TODO: Wire to a real "saved address" endpoint once available.
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        return PatientAddress(line1: "123 Serenity Lane", line2: "Apt 4B", district: "Health District")
    }

    func submitCareRequest(_ request: CareRequest) async throws {
        // TODO: Wire to a real "submit care request" endpoint once available.
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
    }
}
