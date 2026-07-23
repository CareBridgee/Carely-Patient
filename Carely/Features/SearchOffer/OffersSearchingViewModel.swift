//
//  OffersSearchingViewModel.swift
//  Carely
//
//  Created by Mona Zarea on 22/07/2026.
//

import Foundation

@MainActor
final class OffersSearchingViewModel: ObservableObject {
    @Published var offers: [NurseOffer] = []
    
    private let observeOffersUseCase: ObserveOffersUseCase
    private let manageOffersConnectionUseCase: ManageOffersConnectionUseCase
    private let requestId: String
    var onOfferAccepted: ((ConfirmedOffer) -> Void)
    var onOfferDeclined: ((String) -> Void)
    
    init(
        requestId: String,
        observeOffersUseCase: ObserveOffersUseCase,
        manageOffersConnectionUseCase: ManageOffersConnectionUseCase,
        onOfferAccepted: @escaping (ConfirmedOffer) -> Void = { _ in },
        onOfferDeclined: @escaping (String) -> Void = { _ in }
    ) {
        self.requestId = requestId
        self.observeOffersUseCase = observeOffersUseCase
        self.manageOffersConnectionUseCase = manageOffersConnectionUseCase
        self.onOfferAccepted = onOfferAccepted
        self.onOfferDeclined = onOfferDeclined
    }
    
    func startSearching() {
        manageOffersConnectionUseCase.connect()
            
        Task {
            for await event in observeOffersUseCase.execute() {
                handleEvent(event)
            }
        }
    }
        
    private func handleEvent(_ event: OffersEvent) {
        switch event {
        case .offerReceived(let offer):
            self.offers.insert(offer, at: 0)
                
        case .offerCanceled(let offerId):
            self.offers.removeAll { $0.id == offerId }
                
        case .searchCompleted:
            break
        }
    }
        
    func cancelSearch() {
        manageOffersConnectionUseCase.disconnect()
    }
    
    func declineOffer(offerId: String) {
        self.offers.removeAll { $0.id == offerId }
    }
        
    func acceptOffer(offerId: String) {
        cancelSearch()
        
        // Mock API Response mapped to ConfirmedOffer
        guard let offer = offers.first(where: { $0.id == offerId }) else { return }
        
        let nurseDetails = ConfirmedOffer.NurseDetails(
            id: offer.id,
            fullName: offer.name,
            title: offer.title,
            specialty: "Geriatric", // Mock data
            profileImageUrl: offer.imageLink,
            rating: offer.rating,
            reviewsCount: offer.reviewsCount
        )
        
        let confirmedOffer = ConfirmedOffer(
            id: UUID().uuidString,
            status: "CONFIRMED",
            estimatedArrival: "10:30 AM",
            distanceKm: offer.distance,
            qrCodeData: "mock-qr-token-\(offer.id)",
            cancellationDeadline: "10:32 AM",
            nurse: nurseDetails,
            contact: ConfirmedOffer.ContactDetails(phoneNumber: "+1234567890", chatChannelId: "chat_123")
        )
        
        onOfferAccepted(confirmedOffer)
    }
}
