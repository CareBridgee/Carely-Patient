//
//  AIPatientRepositoryProtocol.swift
//  Carely
//
//  Created by AI Assistant
//

import Foundation

protocol AIPatientRepositoryProtocol {
    func getPatients() async throws -> [AIPatient]
}
