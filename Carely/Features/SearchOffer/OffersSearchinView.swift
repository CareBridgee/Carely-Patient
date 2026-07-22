//
//  OffersSearchinView.swift
//  Carely
//
//  Created by Mona Zarea on 22/07/2026.
//

import SwiftUI

struct OffersSearchingView: View {
    @StateObject private var viewModel: OffersSearchingViewModel
    
    init(viewModel: OffersSearchingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            AppHeader(title: "Request Status", trailingIcon: "ellipsis")
                .padding(.horizontal, Spacing.s20)
            
            ScrollView {
                VStack(spacing: Spacing.s24) {
                    SearchingIndicatorView(activeNursesCount: max(3, viewModel.offers.count))
                        .padding(.top, Spacing.s16)
                    
                    VStack(spacing: Spacing.s16) {
                        ForEach(viewModel.offers) { offer in
                            NurseOfferCardView(offer: offer)
                        }
                    }
                    .padding(.horizontal, Spacing.s20)
                    .padding(.bottom, Spacing.s24)
                }
            }
            .background(Color.backGround.ignoresSafeArea())
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.offers)
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            viewModel.startSearching()
        }
        .onDisappear {
            viewModel.cancelSearch()
        }
    }
}

#Preview {
    class MockOfferSearchingRepository: OfferSearchingRepositoryProtocol {
        func observeOffers() -> AsyncStream<BookingEvent> {
            return AsyncStream { continuation in
                let offer1 = NurseOffer(id: "1", name: "Sarah Mitchell", title: "RN", price: 85.00, rating: 4.9, reviewsCount: 124, distance: 2.4, imageLink: "")
                let offer2 = NurseOffer(id: "2", name: "Elena Rodriguez", title: "RN", price: 78.00, rating: 5.0, reviewsCount: 45, distance: 5.1, imageLink: "")
                
                continuation.yield(.offerReceived(offer1))
                continuation.yield(.offerReceived(offer2))
            }
        }
        func connect() {}
        func disconnect() {}
    }
    
    let mockRepo = MockOfferSearchingRepository()
    let observeUseCase = ObserveOffersUseCase(repository: mockRepo)
    let manageConnectionUseCase = ManageOffersConnectionUseCase(repository: mockRepo)
    let viewModel = OffersSearchingViewModel(
        observeOffersUseCase: observeUseCase,
        manageOffersConnectionUseCase: manageConnectionUseCase
    )
    
    return OffersSearchingView(viewModel: viewModel)
}
