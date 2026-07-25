//
//  CareRequestViewModel.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//

import Foundation

enum CareRequestEntryPoint {
    case aiChat
    case manual
}

@MainActor
final class CareRequestViewModel: ObservableObject {

    let entryPoint: CareRequestEntryPoint
    var showsFillWithAI: Bool { entryPoint == .aiChat }

    @Published var selectedPatient: PatientRelation = .self_
    @Published var selectedService: CareService
    @Published var availableServices: [CareService] = []

    @Published var description: String = "" {
        didSet { if !description.isEmpty { descriptionError = nil } }
    }
    @Published private(set) var descriptionError: String?

    @Published var address: PatientAddress?
    @Published private(set) var addressError: String?

    @Published var selectedPaymentMethod: PaymentMethod? {
        didSet { paymentMethodError = nil }
    }
    @Published private(set) var paymentMethodError: String?

    @Published private(set) var isSubmitting = false

    private let fetchAvailableServicesUseCase: FetchAvailableServicesUseCaseProtocol
    private let fetchSavedAddressUseCase: FetchSavedAddressUseCaseProtocol
    private let submitCareRequestUseCase: SubmitCareRequestUseCaseProtocol
    private let onSubmitted: (String) -> Void

    init(
        preselectedService: CareService,
        entryPoint: CareRequestEntryPoint,
        fetchAvailableServicesUseCase: FetchAvailableServicesUseCaseProtocol,
        fetchSavedAddressUseCase: FetchSavedAddressUseCaseProtocol,
        submitCareRequestUseCase: SubmitCareRequestUseCaseProtocol,
        onSubmitted: @escaping (String) -> Void
    ) {
        self.selectedService = preselectedService
        self.entryPoint = entryPoint
        self.fetchAvailableServicesUseCase = fetchAvailableServicesUseCase
        self.fetchSavedAddressUseCase = fetchSavedAddressUseCase
        self.submitCareRequestUseCase = submitCareRequestUseCase
        self.onSubmitted = onSubmitted
    }

    func onAppear() async {
        async let services = fetchAvailableServicesUseCase.execute()
        async let savedAddress = fetchSavedAddressUseCase.execute()

        if let services = try? await services {
            availableServices = services
        }
        address = try? await savedAddress
    }

    func fillWithAI() {
        description = "Feeling dehydrated after the flu, needs routine IV administration and monitoring for the next few hours."
    }

    func submitTapped() {
        guard validate() else { return }

        isSubmitting = true
        let request = CareRequest(
            patient: selectedPatient,
            service: selectedService,
            description: description,
            address: address,
            paymentMethod: selectedPaymentMethod!
        )

        Task {
            try? await submitCareRequestUseCase.execute(request)
            isSubmitting = false
            onSubmitted("mock_req_\(UUID().uuidString.prefix(8))")
        }
    }

    private func validate() -> Bool {
        var isValid = true

        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            descriptionError = "Please describe the situation or symptoms."
            isValid = false
        }

        if address == nil {
            addressError = "Please add an address for this request."
            isValid = false
        }

        if selectedPaymentMethod == nil {
            paymentMethodError = "Please select a payment method."
            isValid = false
        }

        return isValid
    }
}
