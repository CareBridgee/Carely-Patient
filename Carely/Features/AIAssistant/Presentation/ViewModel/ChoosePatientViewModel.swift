//
//  ChoosePatientViewModel.swift
//  Carely
//
//  Created by AI Assistant
//

import Foundation
import Combine

@MainActor
class ChoosePatientViewModel: ObservableObject {
    @Published var patients: [AIPatient] = []
    @Published var selectedPatientId: String? = nil
    @Published var isLoading = false
    @Published var greetingName: String = ""
    @Published var profileImageUrl: String? = nil

    /// True while the patient list is being fetched from the server.
    @Published var isLoadingPatients = false

    /// Drives the full-page `ErrorStateView` when the initial patient list
    /// fetch fails and there's nothing cached to show yet.
    @Published var loadError: Error?

    /// Drives the `.errorToast` when a background refresh of the patient
    /// list fails but a previously loaded list is already on screen.
    @Published var errorMessage: String? = nil

    private let patientProfilesStore: PatientProfilesStore
    private let sessionManager: SessionManager
    private let profileRepository: ProfileRepositoryProtocol?
    private let getAIPatientsUseCase: GetAIPatientsUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    let onShowPatientDetails: ((String) -> Void)?
    let onContinueWithAssessmentClosure: (String) -> Void
    var onAddFamilyMember: (() -> Void)?

    init(
        patientProfilesStore: PatientProfilesStore,
        sessionManager: SessionManager,
        profileRepository: ProfileRepositoryProtocol? = nil,
        getAIPatientsUseCase: GetAIPatientsUseCaseProtocol,
        onShowPatientDetails: ((String) -> Void)?,
        onContinueWithAssessment: @escaping (String) -> Void,
        onAddFamilyMember: (() -> Void)? = nil
    ) {
        self.patientProfilesStore = patientProfilesStore
        self.sessionManager = sessionManager
        self.profileRepository = profileRepository
        self.getAIPatientsUseCase = getAIPatientsUseCase
        self.onShowPatientDetails = onShowPatientDetails
        self.onContinueWithAssessmentClosure = onContinueWithAssessment
        self.onAddFamilyMember = onAddFamilyMember
        bindToStore()
    }

    private func bindToStore() {
        patientProfilesStore.$primaryProfile
            .combineLatest(patientProfilesStore.$familyMembers)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] primary, family in
                self?.updatePatientsList(primary: primary, family: family)
            }
            .store(in: &cancellables)

        sessionManager.$currentUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.greetingName = user?.firstName ?? "User"
                self?.profileImageUrl = user?.profileImageUrl
            }
            .store(in: &cancellables)
    }

    private func updatePatientsList(primary: PatientProfile?, family: [FamilyMember]) {
        var list: [AIPatient] = []
        if let p = primary {
            list.append(AIPatient(
                id: p.id,
                name: p.displayName,
                relation: "self",
                isSelf: true,
                imageUrl: p.profileImageUrl
            ))
        }
        list.append(contentsOf: family.map { f in
            AIPatient(
                id: f.id,
                name: f.name,
                relation: f.relation,
                isSelf: false,
                imageUrl: f.profileImageUrl
            )
        })
        
        self.patients = list
        
        if self.selectedPatientId == nil {
            if let primary = list.first(where: { $0.isSelf }) {
                self.selectedPatientId = primary.id
            } else if let first = list.first {
                self.selectedPatientId = first.id
            }
        }
    }

    func onAppear() async {
        guard let profileRepository else { return }
        // If data is already populated from store, do not show loading spinner/skeleton
        if patients.isEmpty {
            isLoading = true
        }
        async let fetchProfile: () = {
            _ = try? await profileRepository.fetchPatientProfile()
        }()
        async let fetchFamily: () = {
            _ = try? await profileRepository.fetchFamilyMembers()
        }()
        _ = await (fetchProfile, fetchFamily)
        isLoading = false
        // The store-driven binding above shows any already-cached profiles
        // immediately; this actively (re)fetches the patient list from the
        // server so a stale or empty store doesn't leave the screen blank,
        // and so a failed fetch is surfaced instead of silently ignored.
        await fetchPatients()
    }

    private func fetchPatients() async {
        isLoadingPatients = true
        loadError = nil

        do {
            let fetched = try await getAIPatientsUseCase.execute()
            self.patients = fetched
            self.isLoadingPatients = false

            if selectedPatientId == nil || !fetched.contains(where: { $0.id == selectedPatientId }) {
                if let primary = fetched.first(where: { $0.isSelf }) {
                    self.selectedPatientId = primary.id
                } else {
                    self.selectedPatientId = fetched.first?.id
                }
            }
        } catch {
            self.isLoadingPatients = false
            if self.patients.isEmpty {
                // Nothing to show at all — full-page error state with retry.
                self.loadError = error
            } else {
                // We already have a list on screen (e.g. from the store);
                // don't replace it with an empty state, just notify.
                self.errorMessage = error.carelyDescription
            }
        }
    }

    func retryLoadPatients() {
        Task { await fetchPatients() }
    }

    func selectPatient(_ patient: AIPatient) {
        selectedPatientId = patient.id
    }

    func continueWithAssessment() {
        guard let selectedId = selectedPatientId else { return }
        onContinueWithAssessmentClosure(selectedId)
    }
}
