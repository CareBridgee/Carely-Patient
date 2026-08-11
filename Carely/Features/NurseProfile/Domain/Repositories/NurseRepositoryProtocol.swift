//
//  NurseRepositoryProtocol.swift
//  Carely
//
//  Created by Mina on 08/08/2026.
//

import Foundation

protocol NurseRepositoryProtocol {
    func getNurseProfile(id: String) async throws -> NurseDetails
}
