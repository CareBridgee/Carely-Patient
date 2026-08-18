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

    
    init(
        serviceRequestId: String,
        fallbackQrCodeData: String = "",
        referenceNumber: String = "",
        serviceRequestService: ServiceRequestServiceProtocol? = nil,
        onClose: @escaping () -> Void
    ) {
        self.serviceRequestId = serviceRequestId
        self.qrCodeData = fallbackQrCodeData
        self.referenceNumber = referenceNumber
        self.serviceRequestService = serviceRequestService
        self.onCloseAction = onClose
        self.isLoading = (serviceRequestService != nil && !serviceRequestId.isEmpty)
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
