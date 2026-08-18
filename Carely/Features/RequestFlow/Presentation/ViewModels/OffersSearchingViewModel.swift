//
//  OffersSearchingViewModel.swift
//  Carely
//
//  Created by Mona Zarea on 22/07/2026.
//

import Foundation
import UIKit

@MainActor
final class OffersSearchingViewModel: ObservableObject {
    @Published var offers: [NurseOffer] = []
    @Published var errorMessage: String? = nil
    @Published var isCancelling: Bool = false
    @Published var isNavigatingForward: Bool = false
    @Published var showCancelSearchConfirmation: Bool = false
    
    @Published var showSplitPaymentAlert: Bool = false
    @Published var splitPaymentCashAmount: Double = 0.0
    
    var isSearchResolved: Bool = false
    
    private let observeOffersUseCase: ObserveOffersUseCase
    private let manageOffersConnectionUseCase: ManageOffersConnectionUseCase
    private let acceptOfferUseCase: AcceptOfferUseCase
    private let declineOfferUseCase: DeclineOfferUseCase
    private let cancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol
    private let walletService: WalletServiceProtocol
    
    private let requestId: String
    private let isWalletPayment: Bool
    
    var onOfferAccepted: ((ConfirmedOffer) -> Void)
    var onOfferDeclined: ((String) -> Void)
    var onShowNurseProfile: ((String) -> Void)
    var onSearchCanceled: (() -> Void)
    @Published var pendingAcceptedOffer: ConfirmedOffer? = nil
    init(
        requestId: String,
        isWalletPayment: Bool,
        observeOffersUseCase: ObserveOffersUseCase,
        manageOffersConnectionUseCase: ManageOffersConnectionUseCase,
        acceptOfferUseCase: AcceptOfferUseCase,
        declineOfferUseCase: DeclineOfferUseCase,
        cancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol,
        walletService: WalletServiceProtocol,
        onOfferAccepted: @escaping (ConfirmedOffer) -> Void = { _ in },
        onOfferDeclined: @escaping (String) -> Void = { _ in },
        onShowNurseProfile: @escaping (String) -> Void = { _ in },
        onSearchCanceled: @escaping () -> Void = { }
    ) {
        self.requestId = requestId
        self.isWalletPayment = isWalletPayment
        self.observeOffersUseCase = observeOffersUseCase
        self.manageOffersConnectionUseCase = manageOffersConnectionUseCase
        self.acceptOfferUseCase = acceptOfferUseCase
        self.declineOfferUseCase = declineOfferUseCase
        self.cancelServiceRequestUseCase = cancelServiceRequestUseCase
        self.walletService = walletService
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
                 isSearchResolved = true
                 cancelSearch()
                 
                 let nurseDetails = ConfirmedOffer.NurseDetails(
                     id: offer.nurseId, fullName: offer.name, title: offer.title, specialty: offer.specialty,
                     profileImageUrl: offer.imageLink, rating: offer.rating, reviewsCount: offer.reviewsCount
                 )
                 
                 let confirmedOffer = ConfirmedOffer(
                     id: requestId, status: "CONFIRMED", estimatedArrival: offer.estimatedArrival, distanceKm: offer.distance,
                     qrCodeData: "mock-qr-token-\(offer.id)", cancellationDeadline: "10:32 AM", nurse: nurseDetails,
                     contact: ConfirmedOffer.ContactDetails(phoneNumber: "+1234567890", chatChannelId: "chat_123")
                 )
                 
                 
                 if showSplitPaymentAlert {
                     self.pendingAcceptedOffer = confirmedOffer
                 } else {
                     onOfferAccepted(confirmedOffer)
                 }
            
        case .requestCanceled:
                    isSearchResolved = true
                    cancelSearch()
                    Task {
                        await processLiveRefund() // Wait for the refund
                        onSearchCanceled()        // Then pop the screen
                    }
            
        case .searchCompleted, .visitCompleted:
            break
        }
    }
    
    func cancelSearch() {
        manageOffersConnectionUseCase.disconnect()
    }
    
    func cancelServiceRequest() {
        showCancelSearchConfirmation = true
    }
    func acknowledgeSplitPayment() {
            showSplitPaymentAlert = false
            if let pending = pendingAcceptedOffer {
                onOfferAccepted(pending)
                self.pendingAcceptedOffer = nil
            }
        }
    func confirmCancelServiceRequest() {
            isCancelling = true
            errorMessage = nil
            Task {
                do {
                    try await cancelServiceRequestUseCase.execute(serviceRequestId: requestId)
                    
                    await processLiveRefund()
                    
                    isCancelling = false
                    isSearchResolved = true
                    cancelSearch()
                    onSearchCanceled()
                } catch {
                    isCancelling = false
                    errorMessage = error.localizedDescription
                }
            }
        }
    
    func declineOffer(offerId: String) {
        declineOfferUseCase.execute(offerId: offerId)
        self.offers.removeAll { $0.id == offerId }
    }
    
    func showNurseProfile(nurseId: String) {
        isNavigatingForward = true
        onShowNurseProfile(nurseId)
    }
        
    func acceptOffer(offerId: String) {
            print("🟡 acceptOffer triggered for offerId: \(offerId)")
            print("🟡 isWalletPayment flag is: \(isWalletPayment)")
            
            guard let offer = offers.first(where: { $0.id == offerId }) else {
                print("❌ FAILED: Could not find offer with id \(offerId) in the offers list!")
                return
            }
            
            if isWalletPayment {
                print("💳 Wallet Payment Flow Started")
                isCancelling = true
                
                Task {
                    do {
                        print("🔄 1. Fetching Current User ID...")
                        let userId = try await walletService.getCurrentUserId()
                        print("✅ User ID fetched: \(userId)")
                        
                        print("🔄 2. Fetching Current Credit...")
                        let currentCredit = try await walletService.getCredit(userId: userId)
                        print("✅ Current Credit fetched: \(currentCredit)")
                        
                        let price = offer.price
                        print("💰 Offer Price: \(price), Wallet Credit: \(currentCredit)")
                        
                        var amountToDeduct = 0.0
                        var remainingCash = 0.0
                        
                        if currentCredit >= price {
                            amountToDeduct = price
                        } else if currentCredit > 0 {
                            amountToDeduct = currentCredit
                            remainingCash = price - currentCredit
                        } else {
                            remainingCash = price
                        }
                        
                        if amountToDeduct > 0 {
                            print("🔄 3. Calling DEDUCT API for amount: \(amountToDeduct)...")
                            _ = try await walletService.updateCredit(userId: userId, amount: amountToDeduct, operation: "DEDUCT")
                            print("✅ DEDUCT API Successful!")
                            
                            PendingRefundManager.shared.savePendingRefund(requestId: requestId, amount: amountToDeduct)
                        } else {
                            print("⚠️ No money to deduct from wallet. Full cash payment required.")
                        }
                        
                        if remainingCash > 0 {
                            splitPaymentCashAmount = remainingCash
                            showSplitPaymentAlert = true
                        }
                        
                        print("🔄 4. Executing Accept Offer STOMP/REST call...")
                        acceptOfferUseCase.execute(offerId: offerId)
                        isCancelling = false
                        print("🎉 Wallet Flow Complete!")
                        
                    } catch {
                        isCancelling = false
                        errorMessage = error.localizedDescription
                        print("❌ WALLET FLOW CRASHED WITH ERROR: \(error)")
                    }
                }
            } else {
                print("💵 Cash Payment Flow Started")
                acceptOfferUseCase.execute(offerId: offerId)
            }
        }
    
    private func processLiveRefund() async {
            let pendingRefunds = PendingRefundManager.shared.getAllPendingRefunds()
            guard let refund = pendingRefunds.first(where: { $0.requestId == requestId }) else { return }
            
            do {
                let userId = try await walletService.getCurrentUserId()
                _ = try await walletService.updateCredit(userId: userId, amount: refund.amount, operation: "ADD")
                PendingRefundManager.shared.removeRefund(requestId: requestId)
                print("💰 Refund successful for amount: \(refund.amount)")
            } catch {
                print("❌ Refund failed to reach backend: \(error)")
            }
        }
    
    func abandonSearchIfNeeded() {
            guard !isNavigatingForward, !isSearchResolved else { return }
            isSearchResolved = true
            
            var bgTask: UIBackgroundTaskIdentifier = .invalid
            bgTask = UIApplication.shared.beginBackgroundTask {
                UIApplication.shared.endBackgroundTask(bgTask)
            }
            
            Task {
                try? await cancelServiceRequestUseCase.execute(serviceRequestId: requestId)
                await processLiveRefund()
                UIApplication.shared.endBackgroundTask(bgTask)
            }
        }
    
    func forceCancelOnKill() {
        guard !isNavigatingForward, !isSearchResolved else { return }
        isSearchResolved = true
        
        let semaphore = DispatchSemaphore(value: 0)
        
        Task {
            try? await cancelServiceRequestUseCase.execute(serviceRequestId: requestId)
            await processLiveRefund()
            
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .now() + 1.5)
    }
}
