//
//  CareRequestRepositoryProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


import Foundation
protocol CareRequestRepositoryProtocol {
    func fetchAvailableServices() async throws -> [CareService]
    func fetchPatients() async throws -> [ServiceRequestPatient]
    func fetchAddress(profileId: String) async throws -> ServiceRequestAddress?
    func submitCareRequest(_ request: CareRequest) async throws -> ServiceRequestResult
}
