//
//  SearchingOfferRepositoryImpl.swift
//  Carely
//
//  Created by Mona Zarea on 22/07/2026.
//

import Foundation
final class OfferSearchingRepositoryImpl: OfferSearchingRepositoryProtocol {
    
    
    private var hubService: OffersSearchingHubServicesProtocol
    private var serviceRequestService: ServiceRequestServiceProtocol?
    
    
    init(hubService: OffersSearchingHubServicesProtocol, serviceRequestService: ServiceRequestServiceProtocol? = nil) {
        self.hubService = hubService
        self.serviceRequestService = serviceRequestService
    }
    
    func observeOffers() -> AsyncStream<OffersEvent> {
        AsyncStream { continuation in
            hubService.onOfferReceived = { offer in
                continuation.yield(.offerReceived(offer))
            }
            
            hubService.onOfferCanceled = { offerId in
                continuation.yield(.offerCanceled(offerId))
            }
            
            hubService.onOfferConfirmed = { offer in
                continuation.yield(.offerAccepted(offer))
            }
            
            hubService.onRequestCanceled = {
                continuation.yield(.requestCanceled)
            }
            
            hubService.onVisitCompleted = {
                continuation.yield(.visitCompleted)
            }
            
            continuation.onTermination = { [weak self] _ in
                self?.hubService.onOfferReceived = nil
                self?.hubService.onOfferCanceled = nil
                self?.hubService.onOfferConfirmed = nil
                self?.hubService.onRequestCanceled = nil
                self?.hubService.onVisitCompleted = nil
            }
        }
    }
    
    func connect() {
        hubService.connect()
    }
    
    func disconnect() {
        hubService.disconnect()
    }
    
    func acceptOffer(offerId: String) {
        Task {
            do {
                try await serviceRequestService?.acceptOffer(offerId: offerId)
                print("[OfferSearchingRepository] REST API acceptOffer succeeded")
            } catch {
                print("[OfferSearchingRepository] REST API acceptOffer failed: \(error)")
                // fallback to STOMP if REST fails or is not available
                hubService.acceptOffer(offerId: offerId)
            }
        }
    }
    
    func declineOffer(offerId: String) {
        Task {
            do {
                try await serviceRequestService?.declineOffer(offerId: offerId)
                print("[OfferSearchingRepository] REST API declineOffer succeeded")
            } catch {
                print("[OfferSearchingRepository] REST API declineOffer failed: \(error)")
                // fallback to STOMP if REST fails or is not available
                hubService.declineOffer(offerId: offerId)
            }
        }
    }
    
    func cancelServiceRequest(serviceRequestId: String) async throws {
            do {
                try await serviceRequestService?.cancelServiceRequest(serviceRequestId: serviceRequestId)
                print("[OfferSearchingRepository] REST API cancelServiceRequest succeeded")
            } catch {
                print("[OfferSearchingRepository] REST API cancelServiceRequest failed: \(error)")
                hubService.cancelServiceRequest(serviceRequestId: serviceRequestId)
                
            }
        }
}
