import SwiftUI

struct OfferAcceptedView: View {
    @StateObject private var viewModel: OfferAcceptedViewModel
    
    init(viewModel: OfferAcceptedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: viewModel.goToHomeTapped) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.secondaryFont)
                            .frame(width: 36, height: 36)
                            .background(Color.surface)
                            .clipShape(Circle())
                            .carelyShadow(.sm)
                    }
                }
                .padding(.horizontal, Spacing.s20)
                .padding(.top, Spacing.s8)

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
                            .padding(.top, Spacing.s16)
                            
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
                            onCallTapped: { viewModel.callNurse() },
                            onMessageTapped: { viewModel.messageNurse() },
                            onProfileTapped: { viewModel.showNurseProfile() }
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
                                isPrimaryStyle: true
                            )
                        }
                    }
                    .padding(.horizontal, Spacing.s20)
                    .padding(.bottom, Spacing.s24)
                    .frame(maxWidth: .infinity)
                }
                
                // Bottom Buttons
                VStack(spacing: Spacing.s12) {
                    SecondaryButton(title: "Show QR Code", icon: "qrcode") {
                        viewModel.showQRCode()
                    }

                    SecondaryButton(title: "Back to Home", icon: "house.fill") {
                        viewModel.goToHomeTapped()
                    }
                    
                    PrimaryButton(
                        title: "Cancel",
                        isLoading: viewModel.isCancelling
                    ) {
                        viewModel.cancelRequest()
                    }
                }
                .padding(.horizontal, Spacing.s20)
                .padding(.top, Spacing.s16)
                .padding(.bottom, Spacing.s24)
                .background(Color.backGround.ignoresSafeArea(edges: .bottom))
            }
        }
        .navigationBarHidden(true)
        .alert("Request Canceled", isPresented: $viewModel.showNurseCanceledAlert) {
            Button("OK", role: .cancel) {
                viewModel.handleNurseCanceledConfirmation()
            }
        } message: {
            Text("This request was canceled by the nurse.")
        }
        .alert("Cancel Request?", isPresented: $viewModel.showCancelConfirmation) {
            Button("Keep Request", role: .cancel) {
                viewModel.showCancelConfirmation = false
            }
            Button("Cancel Request", role: .destructive) {
                viewModel.confirmCancelRequest()
            }
        } message: {
            Text("Are you sure you want to cancel this request?")
        }
        .onAppear {
            viewModel.onAppear()
        }
        .errorToast($viewModel.errorMessage)
    }
}

//#Preview {
//    struct MockOfferSearchingRepository: OfferSearchingRepositoryProtocol {
//        func observeOffers() -> AsyncStream<OffersEvent> { AsyncStream { _ in } }
//        func connect() {}
//        func disconnect() {}
//        func acceptOffer(offerId: String) {}
//        func declineOffer(offerId: String) {}
//        func cancelServiceRequest(serviceRequestId: String) async throws {}
//    }
//    
//    struct MockCancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol {
//        func execute(serviceRequestId: String) async throws {}
//    }
//    
//    let mockRepo = MockOfferSearchingRepository()
//    let observeUseCase = ObserveOffersUseCase(repository: mockRepo)
//    let manageConnectionUseCase = ManageOffersConnectionUseCase(repository: mockRepo)
//    let mockCancelUseCase = MockCancelServiceRequestUseCase()
//    
//    let mockOffer = ConfirmedOffer(
//        id: "req_123",
//        status: "CONFIRMED",
//        estimatedArrival: "10:15 AM",
//        distanceKm: 2.4,
//        qrCodeData: "mock-qr-code",
//        cancellationDeadline: "10:30 AM",
//        nurse: ConfirmedOffer.NurseDetails(
//            id: "nurse_1",
//            fullName: "Sarah Mitchell",
//            title: "RN",
//            specialty: "Pediatrics",
//            profileImageUrl: "",
//            rating: 4.9,
//            reviewsCount: 124
//        ),
//        contact: ConfirmedOffer.ContactDetails(
//            phoneNumber: "+1234567890",
//            chatChannelId: "chat_123"
//        )
//    )
//    
//    let viewModel = OfferAcceptedViewModel(
//        request: mockOffer,
//        cancelServiceRequestUseCase: mockCancelUseCase,
//        observeOffersUseCase: observeUseCase,
//        manageOffersConnectionUseCase: manageConnectionUseCase
//    )
//    
//    return OfferAcceptedView(viewModel: viewModel)
//}
