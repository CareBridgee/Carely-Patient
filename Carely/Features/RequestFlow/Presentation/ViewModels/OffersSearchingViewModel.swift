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

    /// Drives the `.errorToast` when cancelling the service request fails.
    @Published var errorMessage: String? = nil
    @Published var isCancelling: Bool = false
    
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
            
        Task { [weak self] in
            guard let stream = self?.observeOffersUseCase.execute() else { return }
            for await event in stream {
                guard let self = self else { break }
                self.handleEvent(event)
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
                id: offer.nurseId,
                fullName: offer.name,
                title: offer.title,
                specialty: offer.specialty,
                profileImageUrl: offer.imageLink,
                rating: offer.rating,
                reviewsCount: offer.reviewsCount
            )
            
            let confirmedOffer = ConfirmedOffer(
                id: requestId,
                status: "CONFIRMED",
                estimatedArrival: offer.estimatedArrival,
                distanceKm: offer.distance,
                qrCodeData: "mock-qr-token-\(offer.id)", // Placeholder
                cancellationDeadline: "10:32 AM", // Placeholder
                nurse: nurseDetails,
                contact: ConfirmedOffer.ContactDetails(phoneNumber: "+1234567890", chatChannelId: "chat_123") // Placeholder
            )
            
            onOfferAccepted(confirmedOffer)
                
        case .requestCanceled:
            cancelSearch()
            onSearchCanceled()
            
        case .searchCompleted, .visitCompleted:
            break
        }
    }
        
    @Published var showCancelSearchConfirmation: Bool = false

    func cancelSearch() {
        manageOffersConnectionUseCase.disconnect()
    }
    
    func cancelServiceRequest() {
        showCancelSearchConfirmation = true
    }

    func confirmCancelServiceRequest() {
        isCancelling = true
        errorMessage = nil
        Task {
            do {
                try await cancelServiceRequestUseCase.execute(serviceRequestId: requestId)
                isCancelling = false
                cancelSearch()
                onSearchCanceled()
            } catch {
                isCancelling = false
                errorMessage = error.carelyDescription
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
