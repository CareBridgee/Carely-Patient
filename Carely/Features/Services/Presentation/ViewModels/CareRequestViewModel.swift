//
//  CareRequestViewModel.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//

import Foundation


enum CareRequestEntryPoint: Hashable {
    case aiChat
    case manual
}

@MainActor
final class CareRequestViewModel: ObservableObject {
    let entryPoint: CareRequestEntryPoint
    var showsFillWithAI: Bool {
        guard entryPoint == .aiChat,
              let description = aiDraft?.serviceDescription else {
            return false
        }

        return description.range(of: "User description:") != nil
    }

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

    // MARK: - AI Draft (optional, only set when entry point is .aiChat)
    private let aiDraft: ReservationDraft?
    private let aiProfileId: String?

    init(
        preselectedService: CareService,
        entryPoint: CareRequestEntryPoint,
        aiDraft: ReservationDraft? = nil,
        aiProfileId: String? = nil,
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
        self.aiDraft = aiDraft
        self.aiProfileId = aiProfileId
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

        if let draft = aiDraft {
            applyAIDraft(draft)
        }

        isLoading = false
    }

    func fillWithAI() {
        if let desc = aiDraft?.serviceDescription, !desc.isEmpty {
            description = formatAIServiceDescription(desc)
        }
    }

    private func formatAIServiceDescription(_ text: String) -> String {
        let requestedServiceMarker = "Requested service:"

        let cleanedText: String
        if let range = text.range(of: requestedServiceMarker) {
            cleanedText = String(text[..<range.lowerBound])
        } else {
            cleanedText = text
        }

        let pattern = #"(\d+)-year-old"#
        let formattedText = cleanedText.replacingOccurrences(
            of: pattern,
            with: "$1 years old",
            options: .regularExpression
        )

        return formattedText
            .replacingOccurrences(
                of: "User description:",
                with: "\nReason for Request:"
            )
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // MARK: - AI Draft Application

    private func applyAIDraft(_ draft: ReservationDraft) {
       
        if let pid = aiProfileId,
           let match = patients.first(where: { $0.id == pid }) {
            selectPatient(match)
        }

        if let sid = draft.serviceTypeId,
           let match = availableServices.first(where: { $0.id == sid }) {
            selectedService = match
        }
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
                    submissionErrorMessage = message ?? "No nurses are currently available near your location. Please try again shortly."
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
