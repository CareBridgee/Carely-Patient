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
        ZStack {
            Color.backGround
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Spacing.s24) {
                    SearchingIndicatorView(activeNursesCount: max(3, viewModel.offers.count))
                        .padding(.top, Spacing.s16)
                    
                    VStack(spacing: Spacing.s16) {
                        ForEach(viewModel.offers) { offer in
                            NurseOfferCardView(offer: offer,
                                onDeclineTapped: {
                                viewModel.declineOffer(offerId: offer.id)
                            },
                                onAcceptTapped: {
                                viewModel.acceptOffer(offerId: offer.id)
                            },
                                onProfileTapped: {
                                viewModel.showNurseProfile(nurseId: offer.id)
                            })
                            .transition(
                                .asymmetric(
                                    insertion: .scale(scale: 0.9).combined(with: .opacity).combined(with: .move(edge: .top)),
                                    removal: .scale(scale: 0.9).combined(with: .opacity)
                                )
                            )
                        }
                    }
                    .padding(.horizontal, Spacing.s20)
                    .padding(.bottom, Spacing.s24)
                }
                .frame(maxWidth: .infinity)
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: viewModel.offers)
        }
        .careConnectNavigationBar(title: "Request Status", trailingIcon: "ellipsis")
        .onAppear {
            viewModel.isNavigatingForward = false
            viewModel.startSearching()
        }
        .onDisappear {
            viewModel.abandonSearchIfNeeded()
            viewModel.cancelSearch()
        }
        // ONLY triggers when the app is completely killed (swiped up)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
            viewModel.forceCancelOnKill()
        }
        .errorToast($viewModel.errorMessage)
        .alert("Wallet Partially Applied", isPresented: $viewModel.showSplitPaymentAlert) {
            Button("OK", role: .cancel) {
                viewModel.acknowledgeSplitPayment()
            }
        } message: {
            Text("Your wallet balance was applied. You will need to pay the remaining \(String(format: "%.2f", viewModel.splitPaymentCashAmount)) EGP in cash to the nurse.")
        }
    }
}
