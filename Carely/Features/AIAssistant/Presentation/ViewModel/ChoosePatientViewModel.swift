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

    private let patientProfilesStore: PatientProfilesStore
    private let sessionManager: SessionManager
    private let profileRepository: ProfileRepositoryProtocol?
    private var cancellables = Set<AnyCancellable>()
    let onShowPatientDetails: ((String) -> Void)?
    let onContinueWithAssessmentClosure: (String) -> Void
    var onAddFamilyMember: (() -> Void)?

    init(
        patientProfilesStore: PatientProfilesStore,
        sessionManager: SessionManager,
        profileRepository: ProfileRepositoryProtocol? = nil,
        onShowPatientDetails: ((String) -> Void)?,
        onContinueWithAssessment: @escaping (String) -> Void,
        onAddFamilyMember: (() -> Void)? = nil
    ) {
        self.patientProfilesStore = patientProfilesStore
        self.sessionManager = sessionManager
        self.profileRepository = profileRepository
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
        isLoading = true
        await Task.withMinimumDuration {
            async let fetchProfile: () = {
                _ = try? await profileRepository.fetchPatientProfile()
            }()
            async let fetchFamily: () = {
                _ = try? await profileRepository.fetchFamilyMembers()
            }()
            _ = await (fetchProfile, fetchFamily)
        }
        isLoading = false
    }

    func selectPatient(_ patient: AIPatient) {
        selectedPatientId = patient.id
    }

    func continueWithAssessment() {
        guard let selectedId = selectedPatientId else { return }
        onContinueWithAssessmentClosure(selectedId)
    }
}

