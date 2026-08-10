//
//  AcceptOfferUseCase.swift
//  Carely
//
//  Created by AI on 22/07/2026.
//

import Foundation

struct AcceptOfferUseCase {
    private let repository: OfferSearchingRepositoryProtocol
    
    init(repository: OfferSearchingRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(offerId: String) {
        repository.acceptOffer(offerId: offerId)
    }
}
