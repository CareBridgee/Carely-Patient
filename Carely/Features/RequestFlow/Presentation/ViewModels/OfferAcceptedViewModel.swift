import Foundation

@MainActor
final class OfferAcceptedViewModel: ObservableObject {
    @Published var request: ConfirmedOffer
    @Published var showNurseCanceledAlert = false
    
    private var isCanceledByMe = false
    
    private let onShowQRCode: (ConfirmedOffer) -> Void
    private let onCancelRequest: () -> Void
    private let onShowNurseProfile: (String) -> Void
    private let onMessageNurse: (String) -> Void
    private let onVisitCompleted: () -> Void
    private let cancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol
    private let observeOffersUseCase: ObserveOffersUseCase
    private let manageOffersConnectionUseCase: ManageOffersConnectionUseCase
    private let activeVisitStore: ActiveVisitStore?
    private let historyService: HistoryServiceProtocol?
    
    init(
        request: ConfirmedOffer,
        cancelServiceRequestUseCase: CancelServiceRequestUseCaseProtocol,
        observeOffersUseCase: ObserveOffersUseCase,
        manageOffersConnectionUseCase: ManageOffersConnectionUseCase,
        activeVisitStore: ActiveVisitStore? = nil,
        historyService: HistoryServiceProtocol? = nil,
        onShowQRCode: @escaping (ConfirmedOffer) -> Void = { _ in },
        onCancelRequest: @escaping () -> Void = {},
        onShowNurseProfile: @escaping (String) -> Void = { _ in },
        onMessageNurse: @escaping (String) -> Void = { _ in },
        onVisitCompleted: @escaping () -> Void = {}
    ) {
        self.request = request
        self.cancelServiceRequestUseCase = cancelServiceRequestUseCase
        self.activeVisitStore = activeVisitStore
        self.historyService = historyService
        self.onShowQRCode = onShowQRCode
        self.onCancelRequest = onCancelRequest
        self.onShowNurseProfile = onShowNurseProfile
        self.onMessageNurse = onMessageNurse
        self.onVisitCompleted = onVisitCompleted
        self.observeOffersUseCase = observeOffersUseCase
        self.manageOffersConnectionUseCase = manageOffersConnectionUseCase
    }
    
    func onAppear() {
        manageOffersConnectionUseCase.connect()
        checkRequestStatus()
        Task { [weak self] in
            guard let stream = self?.observeOffersUseCase.execute() else { return }
            for await event in stream {
                guard let self = self else { break }
                switch event {
                case .requestCanceled:
                    self.activeVisitStore?.clearActiveVisit()
                    if !self.isCanceledByMe {
                        self.showNurseCanceledAlert = true
                    }
                case .visitCompleted:
                    self.activeVisitStore?.clearActiveVisit()
                    self.manageOffersConnectionUseCase.disconnect()
                    self.onVisitCompleted()
                default:
                    break
                }
            }
        }
    }

    private func checkRequestStatus() {
        guard let service = historyService else { return }
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let detail = try await service.getRequestDetail(id: self.request.id)
                let status = detail.status?.uppercased() ?? ""
                if status == "CANCELLED" || status == "CANCELED" || status == "NURSE_CANCELLED" || status == "NURSE_CANCELED" || status == "REJECTED" {
                    self.activeVisitStore?.clearActiveVisit()
                    if !self.isCanceledByMe {
                        self.showNurseCanceledAlert = true
                    }
                }
            } catch {}
        }
    }
    
    func handleNurseCanceledConfirmation() {
        activeVisitStore?.clearActiveVisit()
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
    
    func cancelRequest() {
        isCanceledByMe = true
        activeVisitStore?.clearActiveVisit()
        Task {
            do {
                try await cancelServiceRequestUseCase.execute(serviceRequestId: request.id)
            } catch {
                print("Failed to cancel request: \(error)")
                isCanceledByMe = false
            }
            onCancelRequest()
        }
    }
}
