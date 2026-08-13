//
//  ProfileRepositoryProtocol.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation
import UIKit

enum ProfileError: LocalizedError {
    case unknown
    case notFound

    var errorDescription: String? {
        switch self {
        case .unknown:  return "Something went wrong. Please try again."
        case .notFound: return "Profile not found."
        }
    }
}

protocol ProfileRepositoryProtocol {
    func fetchPatientProfile() async throws -> PatientProfile
    func fetchFamilyMembers() async throws -> [FamilyMember]
    func updateProfile(id: String, params: ProfileUpdateRequestParams, image: UIImage?) async throws
    func createProfile(params: ProfileUpdateRequestParams, image: UIImage?) async throws -> PatientProfile
}
