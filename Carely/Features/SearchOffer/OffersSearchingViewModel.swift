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
    
    init(
        observeOffersUseCase: ObserveOffersUseCase,
        manageOffersConnectionUseCase: ManageOffersConnectionUseCase
    ) {
        self.observeOffersUseCase = observeOffersUseCase
        self.manageOffersConnectionUseCase = manageOffersConnectionUseCase
    }
    
    func startSearching() {
        manageOffersConnectionUseCase.connect()
            
            Task {
                for await event in observeOffersUseCase.execute() {
                    handleEvent(event)
                }
            }
        }
        
        private func handleEvent(_ event: BookingEvent) {
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
           // self.offers.removeAll { $0.id == offerId }
            
        }
        
        func acceptOffer(offerId: String) {
            
           // cancelSearch()
            
        }
}
