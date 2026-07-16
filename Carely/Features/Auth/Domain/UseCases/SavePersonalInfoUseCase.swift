//
//  file.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation
protocol SavePersonalInfoUseCaseProtocol{
    func execute(basicInfo:BasicUserInfo) async throws 
}

final class SavePersonalInfoUseCase: SavePersonalInfoUseCaseProtocol{
    private let repository: AuthRepositoryProtocol
    
    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(basicInfo:BasicUserInfo) async throws  {
        try await repository.savePersonalInfo(basicInfo:basicInfo)
    }
}
