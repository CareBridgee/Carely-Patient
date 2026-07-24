//
//  ObserveOffersUseCase.swift
//  Carely
//
//  Created by Mona Zarea on 22/07/2026.
//

import Foundation
final class ObserveOffersUseCase {
    private var repository: OfferSearchingRepositoryProtocol
    
    init(repository: OfferSearchingRepositoryProtocol) {
        self.repository = repository
    }
    
 
    func execute()->AsyncStream<OffersEvent>{
        return repository.observeOffers()
    }
}
