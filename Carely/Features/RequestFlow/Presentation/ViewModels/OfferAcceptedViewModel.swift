import Foundation

@MainActor
final class OfferAcceptedViewModel: ObservableObject {
    @Published var request: ConfirmedOffer
    
    private let onShowQRCode: (ConfirmedOffer) -> Void
    private let onCancelRequest: () -> Void
    private let onShowNurseProfile: (String) -> Void
    private let cancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol
    
    init(
        request: ConfirmedOffer,
        cancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol,
        onShowQRCode: @escaping (ConfirmedOffer) -> Void = { _ in },
        onCancelRequest: @escaping () -> Void = {},
        onShowNurseProfile: @escaping (String) -> Void = { _ in }
    ) {
        self.request = request
        self.cancelServiceRequestUseCase = cancelServiceRequestUseCase
        self.onShowQRCode = onShowQRCode
        self.onCancelRequest = onCancelRequest
        self.onShowNurseProfile = onShowNurseProfile
    }
    
    func callNurse() {
        // Handle call action
    }
    
    func messageNurse() {
        // Handle message action
    }
    
    func showNurseProfile() {
        onShowNurseProfile(request.nurse.id)
    }
    
    func showQRCode() {
        onShowQRCode(request)
    }
    
    func cancelRequest() {
        Task {
            do {
                try await cancelServiceRequestUseCase.execute(serviceRequestId: request.id)
            } catch {
                print("Failed to cancel request: \(error)")
            }
            onCancelRequest()
        }
    }
}
