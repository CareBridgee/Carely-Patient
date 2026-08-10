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

    @Published private(set) var patients: [ServiceRequestPatient] = []
    @Published private(set) var selectedPatient: ServiceRequestPatient?

    @Published var selectedService: CareService
    @Published var availableServices: [CareService] = []

    @Published var description: String = ""
    @Published private(set) var descriptionError: String?   

    var displayedDescriptionError: String? {
   
        description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? descriptionError : nil
    }

    @Published private(set) var address: ServiceRequestAddress?
    @Published private(set) var addressError: String?
    @Published private(set) var addressSheetViewModel: HomeAddressViewModel?

    @Published private(set) var isLoading = false
    @Published private(set) var isSubmitting = false
    @Published var submissionErrorMessage: String?
    @Published var showSubmissionError = false

    private let fetchAvailableServicesUseCase: FetchAvailableServicesUseCaseProtocol
    private let fetchPatientsUseCase: FetchPatientsUseCaseProtocol
    private let fetchProfileAddressUseCase: FetchProfileAddressUseCaseProtocol
    private let submitCareRequestUseCase: SubmitCareRequestUseCaseProtocol
    private let makeAddressSheetViewModel: (
        _ profileId: String,
        _ initialAddress: HomeAddress?,
        _ onSaved: @escaping () -> Void,
        _ onDismiss: @escaping () -> Void
    ) -> HomeAddressViewModel
    private let onSubmitted: (String) -> Void

    init(
        preselectedService: CareService,
        entryPoint: CareRequestEntryPoint,
        fetchAvailableServicesUseCase: FetchAvailableServicesUseCaseProtocol,
        fetchPatientsUseCase: FetchPatientsUseCaseProtocol,
        fetchProfileAddressUseCase: FetchProfileAddressUseCaseProtocol,
        submitCareRequestUseCase: SubmitCareRequestUseCaseProtocol,
        makeAddressSheetViewModel: @escaping (
            _ profileId: String,
            _ initialAddress: HomeAddress?,
            _ onSaved: @escaping () -> Void,
            _ onDismiss: @escaping () -> Void
        ) -> HomeAddressViewModel,
        onSubmitted: @escaping (String) -> Void
    ) {
        self.selectedService = preselectedService
        self.entryPoint = entryPoint
        self.fetchAvailableServicesUseCase = fetchAvailableServicesUseCase
        self.fetchPatientsUseCase = fetchPatientsUseCase
        self.fetchProfileAddressUseCase = fetchProfileAddressUseCase
        self.submitCareRequestUseCase = submitCareRequestUseCase
        self.makeAddressSheetViewModel = makeAddressSheetViewModel
        self.onSubmitted = onSubmitted
    }

    func onAppear() async {
        isLoading = true

        async let servicesTask = fetchAvailableServicesUseCase.execute()
        async let patientsTask = fetchPatientsUseCase.execute()

        if let services = try? await servicesTask {
            availableServices = services
        }

        do {
            let fetchedPatients = try await patientsTask
            patients = fetchedPatients
            if let defaultPatient = fetchedPatients.first(where: { $0.isPrimary }) ?? fetchedPatients.first {
                selectedPatient = defaultPatient
                await loadAddress()
            }
        } catch {
            submissionErrorMessage = "We couldn't load your profiles. Please try again."
            showSubmissionError = true
        }

        isLoading = false
    }

    func fillWithAI() {
        description = "Feeling dehydrated after the flu, needs routine IV administration and monitoring for the next few hours."
    }

    func selectPatient(_ patient: ServiceRequestPatient) {
        guard patient.id != selectedPatient?.id else { return }
        selectedPatient = patient
        address = nil
        addressError = nil
        Task { await loadAddress() }
    }

    private func loadAddress() async {
        guard let profileId = selectedPatient?.id else { return }
        do {
            address = try await fetchProfileAddressUseCase.execute(profileId: profileId)
            addressError = nil
        } catch {
            address = nil
            addressError = "Couldn't load the saved address. Please try again."
        }
    }

    // MARK: - Address sheet

    func addOrEditAddressTapped() {
        guard let profileId = selectedPatient?.id else { return }
        addressSheetViewModel = makeAddressSheetViewModel(
            profileId,
            address?.asHomeAddress,
            { [weak self] in Task { await self?.addressSheetSaved() } },
            { [weak self] in self?.dismissAddressSheet() }
        )
    }

    func dismissAddressSheet() {
        addressSheetViewModel = nil
    }

    private func addressSheetSaved() async {
        addressSheetViewModel = nil
        await loadAddress()
    }

    // MARK: - Submit

    func submitTapped() {
        guard validate() else { return }
        guard NetworkMonitor.shared.isConnected else {
            submissionErrorMessage = "No internet connection. Please check your network."
            showSubmissionError = true
            return
        }
        guard let patient = selectedPatient else { return }

        isSubmitting = true
        submissionErrorMessage = nil

        let request = CareRequest(
            patient: patient,
            service: selectedService,
            description: description,
            address: address
        )

        Task {
            do {
                let result = try await submitCareRequestUseCase.execute(request)
                isSubmitting = false
                onSubmitted(result.serviceRequestId)
            } catch let error as NetworkError {
                isSubmitting = false
                if case .server(400, let message) = error {
                    if let msg = message, msg.contains("active service request") {
                        submissionErrorMessage = "This patient already has an active care request. Please wait for it to complete or cancel it before submitting a new one."
                    } else {
                        submissionErrorMessage = message ?? "No nurses are currently available near your location. Please try again shortly."
                    }
                } else {
                    submissionErrorMessage = error.localizedDescription
                }
                showSubmissionError = true
            } catch {
                isSubmitting = false
                submissionErrorMessage = error.localizedDescription
                showSubmissionError = true
            }
        }
    }
    func refreshPatients() async {
        if let fetched = try? await fetchPatientsUseCase.execute() {
            patients = fetched
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
        if selectedPatient == nil {
            isValid = false
        }
        return isValid
    }
}
