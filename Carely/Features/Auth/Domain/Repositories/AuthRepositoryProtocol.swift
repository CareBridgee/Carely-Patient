//
//  file.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation

protocol AuthRepositoryProtocol{
    func savePersonalInfo(
        basicInfo: BasicUserInfo
        ) async throws
}
