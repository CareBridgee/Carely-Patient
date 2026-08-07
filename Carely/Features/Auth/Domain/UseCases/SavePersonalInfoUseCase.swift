//
//  SavePersonalInfoUseCase.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation

protocol SavePersonalInfoUseCaseProtocol {
    func execute(basicInfo: BasicUserInfo) async throws
}

final class SavePersonalInfoUseCase: SavePersonalInfoUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    private let sessionManager: SessionManager
    
    init(repository: AuthRepositoryProtocol, sessionManager: SessionManager) {
        self.repository = repository
        self.sessionManager = sessionManager
    }

    func execute(basicInfo: BasicUserInfo) async throws {
        let cachedProfileId = await sessionManager.currentUser?.defaultProfileId
        
        let newImageUrl = try await repository.savePersonalInfo(basicInfo: basicInfo, defaultProfileId: cachedProfileId)
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let dobString = formatter.string(from: basicInfo.dateOfBirth)
        
        await MainActor.run {
            if var currentUser = sessionManager.currentUser {
                currentUser.firstName = basicInfo.firstName
                currentUser.lastName = basicInfo.secondName
                currentUser.gender = basicInfo.Gender.rawValue
                currentUser.dateOfBirth = dobString
                
                if let newImageUrl = newImageUrl {
                    currentUser.profileImageUrl = newImageUrl
                }
                
                sessionManager.updateUser(currentUser)
            }
        }
    }
}
