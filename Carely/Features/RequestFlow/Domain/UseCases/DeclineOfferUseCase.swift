//
//  DeclineOfferUseCase.swift
//  Carely
//

import Foundation

struct DeclineOfferUseCase {
    private let repository: OfferSearchingRepositoryProtocol
    
    init(repository: OfferSearchingRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(offerId: String) {
        repository.declineOffer(offerId: offerId)
    }
}
