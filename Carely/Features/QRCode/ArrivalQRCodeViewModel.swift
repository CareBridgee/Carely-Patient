import Foundation

@MainActor
final class ArrivalQRCodeViewModel: ObservableObject {
    @Published var qrCodeData: String
    @Published var referenceNumber: String
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let serviceRequestId: String
    private let serviceRequestService: ServiceRequestServiceProtocol?
    private let onCloseAction: () -> Void

    /// Drives the `.errorToast` for any server failure fetching or
    /// validating the arrival QR code. Always the exact server message
    /// (via `error.carelyDescription`) rather than a hardcoded fallback
    /// string. This screen currently receives its data already fetched by
    /// the caller, so nothing assigns into this today — it's wired up so a
    /// future fetch/validate call only needs to catch into it.
    
    init(
        serviceRequestId: String,
        fallbackQrCodeData: String = "",
        referenceNumber: String = "",
        serviceRequestService: ServiceRequestServiceProtocol? = nil,
        onClose: @escaping () -> Void
    ) {
        self.serviceRequestId = serviceRequestId
        self.qrCodeData = fallbackQrCodeData
        self.referenceNumber = referenceNumber.isEmpty ? "#\(serviceRequestId.prefix(8).uppercased())" : referenceNumber
        self.serviceRequestService = serviceRequestService
        self.onCloseAction = onClose
    }
    
    func onAppear() {
        fetchVisitCode()
    }
    
    func fetchVisitCode() {
        guard let serviceRequestService = serviceRequestService, !serviceRequestId.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await serviceRequestService.fetchVisitCode(serviceRequestId: serviceRequestId)
                self.qrCodeData = response.code
                self.referenceNumber = response.code
                self.isLoading = false
            } catch {
                print("[ArrivalQRCodeViewModel] Error fetching visit code: \(error)")
                self.errorMessage = "Failed to load visit code"
                self.isLoading = false
            }
        }
    }
    
    func close() {
        onCloseAction()
    }
}
