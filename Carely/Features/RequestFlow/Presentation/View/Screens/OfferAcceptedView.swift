import SwiftUI

struct OfferAcceptedView: View {
    @StateObject private var viewModel: OfferAcceptedViewModel
    
    init(viewModel: OfferAcceptedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: Spacing.s24) {
                    // Header Section
                    VStack(spacing: Spacing.s16) {
                        // Success Checkmark
                        ZStack {
                            Circle()
                                .fill(Color.brandPrimary)
                                .frame(width: 80, height: 80)
                                .shadow(color: Color.brandPrimary.opacity(0.3), radius: 20, x: 0, y: 10)
                            
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color.surface)
                        }
                        .padding(.top, Spacing.s32)
                        
                        VStack(spacing: Spacing.s8) {
                            Text("Your Nurse Is on the Way!")
                                .carelyText(style: .heading2, weight: .semiBold)
                                .foregroundColor(Color.primaryFont)
                            
                            Text("Your professional nurse is on their\nway to assist you.")
                                .carelyText(style: .bodyRegular)
                                .foregroundColor(Color.secondaryFont)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    // Info Banner
                    OfferAcceptedInfoBannerView()
                    
                    // Nurse Card
                    OfferAcceptedNurseCardView(
                        nurse: viewModel.request.nurse,
                        estimatedArrival: viewModel.request.estimatedArrival,
                        onCallTapped: {
                            viewModel.callNurse()
                        },
                        onMessageTapped: {
                            viewModel.messageNurse()
                        },
                        onProfileTapped: {
                            viewModel.showNurseProfile()
                        }
                    )
                    
                    // Additional Info Cards
                    HStack(spacing: Spacing.s16) {
                        OfferAcceptedInfoCardView(
                            iconName: "mappin.and.ellipse",
                            title: "Distance",
                            subtitle: String(format: "%.1f km", viewModel.request.distanceKm),
                            isPrimaryStyle: true
                        )
                        
                        OfferAcceptedInfoCardView(
                            iconName: "cross.case",
                            title: "Specialty",
                            subtitle: viewModel.request.nurse.specialty,
                            isPrimaryStyle: false
                        )
                    }
                }
                .padding(.horizontal, Spacing.s20)
                .padding(.bottom, Spacing.s24)
            }
            
            // Bottom Buttons
            VStack(spacing: Spacing.s16) {
                SecondaryButton(title: "Show QR Code", icon: "qrcode") {
                    viewModel.showQRCode()
                }
                
                PrimaryButton(title: "Cancel") {
                    viewModel.cancelRequest()
                }
            }
            .padding(.horizontal, Spacing.s20)
          
            .padding(.top, Spacing.s16)
            .background(Color.backGround.ignoresSafeArea(edges: .bottom))
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
        .alert("Request Canceled", isPresented: $viewModel.showNurseCanceledAlert) {
            Button("OK", role: .cancel) {
                viewModel.handleNurseCanceledConfirmation()
            }
        } message: {
            Text("This request was canceled by the nurse.")
        }
        .onAppear {
            viewModel.onAppear()
        }
        Spacer(minLength: Spacing.s64)
        Spacer(minLength: Spacing.s16)
    }
}

#Preview {
    let mockNurse = ConfirmedOffer.NurseDetails(
        id: "nurse_1",
        fullName: "Mark Harrison",
        title: "RN",
        specialty: "Geriatric",
        profileImageUrl: "",
        rating: 4.9,
        reviewsCount: 10
    )
    let mockRequest = ConfirmedOffer(
        id: "bkg_1",
        status: "CONFIRMED",
        estimatedArrival: "10:30 AM",
        distanceKm: 2.4,
        qrCodeData: "carely-bkg-1",
        cancellationDeadline: "",
        nurse: mockNurse,
        contact: ConfirmedOffer.ContactDetails(phoneNumber: "", chatChannelId: "")
    )
    
    class MockCancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol {
        func execute(serviceRequestId: String) async throws {}
    }
    
    class MockOfferSearchingRepository: OfferSearchingRepositoryProtocol {
        func observeOffers() -> AsyncStream<OffersEvent> {
            AsyncStream { _ in }
        }
        func connect() {}
        func disconnect() {}
        func acceptOffer(offerId: String) {}
        func declineOffer(offerId: String) {}
        func cancelServiceRequest(serviceRequestId: String) async throws {}
    }
    
    let mockRepo = MockOfferSearchingRepository()
    
    let viewModel = OfferAcceptedViewModel(
        request: mockRequest,
        cancelServiceRequestUseCase: MockCancelServiceRequestUseCase(),
        observeOffersUseCase: ObserveOffersUseCase(repository: mockRepo),
        manageOffersConnectionUseCase: ManageOffersConnectionUseCase(repository: mockRepo)
    )
    return OfferAcceptedView(viewModel: viewModel)
}
