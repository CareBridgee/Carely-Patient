//
//  MockAIPatientRepository.swift
//  Carely
//
//  Created by AI Assistant
//

import Foundation

class MockAIPatientRepository: AIPatientRepositoryProtocol {
    func getPatients() async throws -> [AIPatient] {
        return [
            AIPatient(id: "1", name: "Elena Rodriguez", relation: "Self", isSelf: true, imageUrl: nil),
            AIPatient(id: "2", name: "Robert Chen", relation: "Dad", isSelf: false, imageUrl: nil),
            AIPatient(id: "3", name: "Margaret Chen", relation: "Mom", isSelf: false, imageUrl: nil)
        ]
    }
}
