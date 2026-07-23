//
//  CareRequestRepositoryImpl.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


import Foundation

final class CareRequestRepositoryImpl: CareRequestRepositoryProtocol {
    private let simulatedDelayNanoseconds: UInt64 = 600_000_000

    func fetchAvailableServices() async throws -> [CareService] {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        return [
            CareService(id: "iv_therapy", title: "IV Therapy", icon: "cross.case.fill"),
            CareService(id: "injection", title: "Injection", icon: "syringe"),
            CareService(id: "blood_collection", title: "Blood Collection", icon: "testtube.2"),
            CareService(id: "wound_dressing", title: "Wound Dressing", icon: "bandage.fill"),
            CareService(id: "elderly_care", title: "Elderly Care", icon: "figure.walk"),
            CareService(id: "physiotherapy", title: "Physiotherapy", icon: "figure.strengthtraining.traditional")
        ]
    }

    func fetchSavedAddress() async throws -> PatientAddress? {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        // Mock: no saved address yet until backend exists.
        return PatientAddress(line1: "123 Serenity Lane", line2: "Apt 4B", district: "Health District")
    }

    func submitCareRequest(_ request: CareRequest) async throws {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
    }
}