//
//  SearchingOfferRepositoryImpl.swift
//  Carely
//
//  Created by Mona Zarea on 22/07/2026.
//

import Foundation
final class OfferSearchingRepositoryImpl: OfferSearchingRepositoryProtocol {
    
    
    private var hubService: OffersSearchingHubServicesProtocol
    
    
    init(hubService: OffersSearchingHubServicesProtocol) {
        self.hubService = hubService
    }
    
    func observeOffers() -> AsyncStream<BookingEvent> {
        AsyncStream { continuation in
            hubService.onOfferReceived = { offer in
                continuation.yield(.offerReceived(offer))
            }
            
            hubService.onOfferCanceled = { offerId in
                continuation.yield(.offerCanceled(offerId))
            }
            
            continuation.onTermination = { [weak self] _ in
                self?.hubService.onOfferReceived = nil
                self?.hubService.onOfferCanceled = nil
            }
        }
    }
    
    func connect() {
        hubService.connect()
    }
    
    func disconnect() {
        hubService.disconnect()
    }
}
