//
//  ProfileRepositoryProtocol.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation

enum ProfileError: LocalizedError {
    case unknown

    var errorDescription: String? {
        "Something went wrong. Please try again."
    }
}

protocol ProfileRepositoryProtocol {
    func fetchPatientProfile() async throws -> PatientProfile
    func fetchFamilyMembers() async throws -> [FamilyMember]
}
