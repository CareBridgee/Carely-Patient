import Foundation

@MainActor
final class OfferAcceptedViewModel: ObservableObject {
    @Published var request: ConfirmedOffer
    @Published var showNurseCanceledAlert = false

    /// Drives the `.errorToast` when cancelling the confirmed request fails.
    @Published var errorMessage: String? = nil
    @Published var isCancelling: Bool = false
    
    private var isCanceledByMe = false
    
    private let onShowQRCode: (ConfirmedOffer) -> Void
    private let onCancelRequest: () -> Void
    private let onShowNurseProfile: (String) -> Void
    private let onMessageNurse: (String) -> Void
    private let cancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol
    private let observeOffersUseCase: ObserveOffersUseCase
    private let manageOffersConnectionUseCase: ManageOffersConnectionUseCase
    
    init(
        request: ConfirmedOffer,
        cancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol,
        observeOffersUseCase: ObserveOffersUseCase,
        manageOffersConnectionUseCase: ManageOffersConnectionUseCase,
        onShowQRCode: @escaping (ConfirmedOffer) -> Void = { _ in },
        onCancelRequest: @escaping () -> Void = {},
        onShowNurseProfile: @escaping (String) -> Void = { _ in },
        onMessageNurse: @escaping (String) -> Void = { _ in }
    ) {
        self.request = request
        self.cancelServiceRequestUseCase = cancelServiceRequestUseCase
        self.onShowQRCode = onShowQRCode
        self.onCancelRequest = onCancelRequest
        self.onShowNurseProfile = onShowNurseProfile
        self.onMessageNurse = onMessageNurse
        self.observeOffersUseCase = observeOffersUseCase
        self.manageOffersConnectionUseCase = manageOffersConnectionUseCase
    }
    
    func onAppear() {
        manageOffersConnectionUseCase.connect()
        Task { [weak self] in
            guard let stream = self?.observeOffersUseCase.execute() else { return }
            for await event in stream {
                guard let self = self else { break }
                if case .requestCanceled = event {
                    if !self.isCanceledByMe {
                        self.showNurseCanceledAlert = true
                    }
                }
            }
        }
    }
    
    func handleNurseCanceledConfirmation() {
        manageOffersConnectionUseCase.disconnect()
        onCancelRequest()
    }
    
    func callNurse() {
        // Handle call action
    }
    
    func messageNurse() {
        onMessageNurse(request.id)
    }
    
    func showNurseProfile() {
        onShowNurseProfile(request.nurse.id)
    }
    
    func showQRCode() {
        onShowQRCode(request)
    }
    
    @Published var showCancelConfirmation: Bool = false

    func cancelRequest() {
        showCancelConfirmation = true
    }

    func confirmCancelRequest() {
        isCanceledByMe = true
        isCancelling = true
        errorMessage = nil
        Task {
            do {
                try await cancelServiceRequestUseCase.execute(serviceRequestId: request.id)
                isCancelling = false
                onCancelRequest()
            } catch {
                isCancelling = false
                isCanceledByMe = false
                errorMessage = error.carelyDescription
            }
        }
    }
}
