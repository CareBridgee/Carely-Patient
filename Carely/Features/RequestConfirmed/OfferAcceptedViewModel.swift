import Foundation

@MainActor
final class OfferAcceptedViewModel: ObservableObject {
    @Published var request: ConfirmedOffer
    
    private let onShowQRCode: (ConfirmedOffer) -> Void
    
    init(request: ConfirmedOffer, onShowQRCode: @escaping (ConfirmedOffer) -> Void = { _ in }) {
        self.request = request
        self.onShowQRCode = onShowQRCode
    }
    
    func callNurse() {
        // Handle call action
    }
    
    func messageNurse() {
        // Handle message action
    }
    
    func showQRCode() {
        onShowQRCode(request)
    }
    
    func cancelRequest() {
        // Handle cancellation
    }
}
