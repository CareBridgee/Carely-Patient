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
    private let acceptOfferUseCase: AcceptOfferUseCase
    private let declineOfferUseCase: DeclineOfferUseCase
    private let cancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol
    private let requestId: String
    var onOfferAccepted: ((ConfirmedOffer) -> Void)
    var onOfferDeclined: ((String) -> Void)
    var onShowNurseProfile: ((String) -> Void)
    var onSearchCanceled: (() -> Void)
    
    init(
        requestId: String,
        observeOffersUseCase: ObserveOffersUseCase,
        manageOffersConnectionUseCase: ManageOffersConnectionUseCase,
        acceptOfferUseCase: AcceptOfferUseCase,
        declineOfferUseCase: DeclineOfferUseCase,
        cancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol,
        onOfferAccepted: @escaping (ConfirmedOffer) -> Void = { _ in },
        onOfferDeclined: @escaping (String) -> Void = { _ in },
        onShowNurseProfile: @escaping (String) -> Void = { _ in },
        onSearchCanceled: @escaping () -> Void = { }
    ) {
        self.requestId = requestId
        self.observeOffersUseCase = observeOffersUseCase
        self.manageOffersConnectionUseCase = manageOffersConnectionUseCase
        self.acceptOfferUseCase = acceptOfferUseCase
        self.declineOfferUseCase = declineOfferUseCase
        self.cancelServiceRequestUseCase = cancelServiceRequestUseCase
        self.onOfferAccepted = onOfferAccepted
        self.onOfferDeclined = onOfferDeclined
        self.onShowNurseProfile = onShowNurseProfile
        self.onSearchCanceled = onSearchCanceled
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
            
        case .offerAccepted(let offer):
            cancelSearch()
            
            // Map NurseOffer to ConfirmedOffer
            let nurseDetails = ConfirmedOffer.NurseDetails(
                id: offer.id,
                fullName: offer.name,
                title: offer.title,
                specialty: "General", // Placeholder
                profileImageUrl: offer.imageLink,
                rating: offer.rating,
                reviewsCount: offer.reviewsCount
            )
            
            let confirmedOffer = ConfirmedOffer(
                id: requestId,
                status: "CONFIRMED",
                estimatedArrival: "10:30 AM", // Placeholder
                distanceKm: offer.distance,
                qrCodeData: "mock-qr-token-\(offer.id)", // Placeholder
                cancellationDeadline: "10:32 AM", // Placeholder
                nurse: nurseDetails,
                contact: ConfirmedOffer.ContactDetails(phoneNumber: "+1234567890", chatChannelId: "chat_123") // Placeholder
            )
            
            onOfferAccepted(confirmedOffer)
                
        case .searchCompleted:
            break
        }
    }
        
    func cancelSearch() {
        manageOffersConnectionUseCase.disconnect()
    }
    
    func cancelServiceRequest() {
        Task {
            do {
                try await cancelServiceRequestUseCase.execute(serviceRequestId: requestId)
                cancelSearch()
                onSearchCanceled()
            } catch {
                print("Failed to cancel service request: \(error)")
            }
        }
    }
    
    func declineOffer(offerId: String) {
        declineOfferUseCase.execute(offerId: offerId)
        self.offers.removeAll { $0.id == offerId }
    }
    
    func showNurseProfile(nurseId: String) {
        onShowNurseProfile(nurseId)
    }
        
    func acceptOffer(offerId: String) {
        acceptOfferUseCase.execute(offerId: offerId)
    }
}
