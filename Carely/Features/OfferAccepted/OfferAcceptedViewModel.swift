import Foundation

@MainActor
final class OfferAcceptedViewModel: ObservableObject {
    @Published var request: ConfirmedOffer
    
    private let onShowQRCode: (ConfirmedOffer) -> Void
    private let onCancelRequest: () -> Void
    private let onShowNurseProfile: (String) -> Void
    
    init(
        request: ConfirmedOffer,
        onShowQRCode: @escaping (ConfirmedOffer) -> Void = { _ in },
        onCancelRequest: @escaping () -> Void = {},
        onShowNurseProfile: @escaping (String) -> Void = { _ in }
    ) {
        self.request = request
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
        // Handle backend cancellation here if needed
        onCancelRequest()
    }
}
