//
//  RepositoryImpl.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation

final class AuthRepositoryImpl: AuthRepositoryProtocol{
    
    init(){
        
    }
    
    func savePersonalInfo(
        basicInfo: BasicUserInfo
    ) async throws{
            
        try await Task.sleep(nanoseconds: 1_500_000_000)
      
            
    }
}
