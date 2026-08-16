import Foundation

@MainActor
final class ArrivalQRCodeViewModel: ObservableObject {
    let qrCodeData: String
    let referenceNumber: String
    private let onCloseAction: () -> Void

    /// Drives the `.errorToast` for any server failure fetching or
    /// validating the arrival QR code. Always the exact server message
    /// (via `error.carelyDescription`) rather than a hardcoded fallback
    /// string. This screen currently receives its data already fetched by
    /// the caller, so nothing assigns into this today — it's wired up so a
    /// future fetch/validate call only needs to catch into it.
    @Published var errorMessage: String? = nil
    
    init(qrCodeData: String, referenceNumber: String, onClose: @escaping () -> Void) {
        self.qrCodeData = qrCodeData
        self.referenceNumber = referenceNumber
        self.onCloseAction = onClose
    }
    
    func close() {
        onCloseAction()
    }
}
