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

    private let getAIPatientsUseCase: GetAIPatientsUseCaseProtocol
    let onShowPatientDetails: ((String) -> Void)?
    let onContinueWithAssessmentClosure: (String) -> Void
    var onAddFamilyMember: (() -> Void)?

    init(
        getAIPatientsUseCase: GetAIPatientsUseCaseProtocol,
        onShowPatientDetails: ((String) -> Void)?,
        onContinueWithAssessment: @escaping (String) -> Void,
        onAddFamilyMember: (() -> Void)? = nil
    ) {
        self.getAIPatientsUseCase = getAIPatientsUseCase
        self.onShowPatientDetails = onShowPatientDetails
        self.onContinueWithAssessmentClosure = onContinueWithAssessment
        self.onAddFamilyMember = onAddFamilyMember
    }

    func onAppear() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let fetchedPatients = try await getAIPatientsUseCase.execute()
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

