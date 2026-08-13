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

    private let getAIPatientsUseCase: GetAIPatientsUseCaseProtocol
    private let getGreetingNameUseCase: GetGreetingNameUseCaseProtocol
    let onShowPatientDetails: ((String) -> Void)?
    let onContinueWithAssessmentClosure: (String) -> Void
    var onAddFamilyMember: (() -> Void)?

    init(
        getAIPatientsUseCase: GetAIPatientsUseCaseProtocol,
        getGreetingNameUseCase: GetGreetingNameUseCaseProtocol,
        onShowPatientDetails: ((String) -> Void)?,
        onContinueWithAssessment: @escaping (String) -> Void,
        onAddFamilyMember: (() -> Void)? = nil
    ) {
        self.getAIPatientsUseCase = getAIPatientsUseCase
        self.getGreetingNameUseCase = getGreetingNameUseCase
        self.onShowPatientDetails = onShowPatientDetails
        self.onContinueWithAssessmentClosure = onContinueWithAssessment
        self.onAddFamilyMember = onAddFamilyMember
    }

    func onAppear() async {
        isLoading = true
        defer { isLoading = false }

        async let patientsTask = getAIPatientsUseCase.execute()
        async let profileTask = getGreetingNameUseCase.execute()

        if let profile = try? await profileTask {
            self.greetingName = profile.name
            self.profileImageUrl = profile.imageUrl
        }

        do {
            let fetchedPatients = try await patientsTask
            self.patients = fetchedPatients
            if self.selectedPatientId == nil {
                // Default to primary / self patient or first patient in list
                if let primary = fetchedPatients.first(where: { $0.isSelf }) {
                    self.selectedPatientId = primary.id
                } else if let first = fetchedPatients.first {
                    self.selectedPatientId = first.id
                }
            }
        } catch {
            print("Error fetching AI patients: \(error)")
        }
    }

    func selectPatient(_ patient: AIPatient) {
        selectedPatientId = patient.id
    }

    func continueWithAssessment() {
        guard let selectedId = selectedPatientId else { return }
        onContinueWithAssessmentClosure(selectedId)
    }
}

