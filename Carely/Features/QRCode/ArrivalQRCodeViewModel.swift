import Foundation

@MainActor
final class ArrivalQRCodeViewModel: ObservableObject {
    let qrCodeData: String
    let referenceNumber: String
    private let onCloseAction: () -> Void
    
    init(qrCodeData: String, referenceNumber: String, onClose: @escaping () -> Void) {
        self.qrCodeData = qrCodeData
        self.referenceNumber = referenceNumber
        self.onCloseAction = onClose
    }
    
    func close() {
        onCloseAction()
    }
}
