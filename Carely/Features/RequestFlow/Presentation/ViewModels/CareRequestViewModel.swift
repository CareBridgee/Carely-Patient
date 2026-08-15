//
//  CareRequestViewModel.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//

import Foundation
import Combine
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
    
    private let patientProfilesStore: PatientProfilesStore
    private var storeCancellables = Set<AnyCancellable>()

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
    private let fetchProfileAddressUseCase: FetchProfileAddressUseCaseProtocol?
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
        fetchProfileAddressUseCase: FetchProfileAddressUseCaseProtocol? = nil,
        submitCareRequestUseCase: SubmitCareRequestUseCaseProtocol,
        patientProfilesStore: PatientProfilesStore,
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
        self.fetchProfileAddressUseCase = fetchProfileAddressUseCase
        self.submitCareRequestUseCase = submitCareRequestUseCase
        self.patientProfilesStore = patientProfilesStore
        self.makeAddressSheetViewModel = makeAddressSheetViewModel
        self.onSubmitted = onSubmitted
    }

    func onAppear() async {
        isLoading = true

        async let servicesTask = fetchAvailableServicesUseCase.execute()
        
        if let services = try? await servicesTask {
            availableServices = services
            if let match = services.first(where: { $0.id == selectedService.id }) {
                selectedService = match
            } else if let first = services.first {
                selectedService = first
            }
        }
        
        bindToStore()

        if let draft = aiDraft {
            applyAIDraft(draft)
        }

        isLoading = false
    }

    private func bindToStore() {
        patientProfilesStore.$primaryProfile
            .combineLatest(patientProfilesStore.$familyMembers)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] primary, family in
                self?.updatePatientsList(primary: primary, family: family)
            }
            .store(in: &storeCancellables)

        patientProfilesStore.$addressesByProfileId
            .receive(on: DispatchQueue.main)
            .sink { [weak self] addresses in
                guard let self = self, let pid = self.selectedPatient?.id else { return }
                if let homeAddress = addresses[pid] {
                    self.address = ServiceRequestAddress(
                        id: "", // Or derived if needed
                        profileId: pid,
                        country: homeAddress.country,
                        city: homeAddress.city,
                        area: homeAddress.area,
                        street: homeAddress.streetName,
                        buildingNumber: homeAddress.building,
                        apartmentNumber: homeAddress.apartment,
                        latitude: homeAddress.latitude ?? 0,
                        longitude: homeAddress.longitude ?? 0
                    )
                } else {
                    self.address = nil
                }
            }
            .store(in: &storeCancellables)
    }

    private func updatePatientsList(primary: PatientProfile?, family: [FamilyMember]) {
        var list: [ServiceRequestPatient] = []
        if let p = primary {
            list.append(ServiceRequestPatient(
                id: p.id,
                firstName: p.firstName,
                lastName: p.lastName,
                relationship: "self",
                isPrimary: true
            ))
        }
        list.append(contentsOf: family.map { f in
            let components = f.name.components(separatedBy: " ")
            return ServiceRequestPatient(
                id: f.id,
                firstName: components.first ?? "",
                lastName: components.dropFirst().joined(separator: " "),
                relationship: f.relation,
                isPrimary: false
            )
        })
        
        self.patients = list
        
        if selectedPatient == nil, let defaultPatient = list.first {
            selectedPatient = defaultPatient
            loadAddressFromStore(for: defaultPatient.id)
        }
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
        addressError = nil
        loadAddressFromStore(for: patient.id)
    }

    private func loadAddressFromStore(for profileId: String) {
        if let homeAddress = patientProfilesStore.addressesByProfileId[profileId] {
            address = ServiceRequestAddress(
                id: "", 
                profileId: profileId,
                country: homeAddress.country,
                city: homeAddress.city,
                area: homeAddress.area,
                street: homeAddress.streetName,
                buildingNumber: homeAddress.building,
                apartmentNumber: homeAddress.apartment,
                latitude: homeAddress.latitude ?? 0,
                longitude: homeAddress.longitude ?? 0
            )
            return
        }

        address = nil

        guard let fetchProfileAddressUseCase = fetchProfileAddressUseCase else { return }
        Task {
            do {
                if let fetched = try await fetchProfileAddressUseCase.execute(profileId: profileId) {
                    guard self.selectedPatient?.id == profileId else { return }
                    self.address = fetched
                    self.patientProfilesStore.updateAddress(profileId: profileId, address: fetched.asHomeAddress)
                }
            } catch {
                // Address not found or failed to load
            }
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
        if let pid = selectedPatient?.id {
            loadAddressFromStore(for: pid)
        }
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
        // Patients are now reactive to patientProfilesStore
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
