//
//  CareRequestRepositoryProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


import Foundation

protocol CareRequestRepositoryProtocol {
    func fetchAvailableServices() async throws -> [CareService]
    func fetchSavedAddress() async throws -> PatientAddress?
    func submitCareRequest(_ request: CareRequest) async throws
}