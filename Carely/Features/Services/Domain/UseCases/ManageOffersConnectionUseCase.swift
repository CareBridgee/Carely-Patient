//
//  ManageOffersConnectionUseCase.swift
//  Carely
//
//  Created by Mona Zarea on 22/07/2026.
//

import Foundation

final class ManageOffersConnectionUseCase {
    private var repository: OfferSearchingRepositoryProtocol
    
    init(repository: OfferSearchingRepositoryProtocol) {
        self.repository = repository
    }
    
    func connect() {
        repository.connect()
    }
    
    func disconnect() {
        repository.disconnect()
    }
}
